import mysql.connector
from mysql.connector import Error

try:
    # Database connection
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password="linalabner777",
        database="library"
    )
    if conn.is_connected():
        print("Successfully connected to the database!")

    cursor = conn.cursor()

    # Fetching all data from the Books table
    print("Fetching all data from the Books table:")
    cursor.execute("SELECT * FROM Books")
    rows = cursor.fetchall()
    for row in rows:
        print(row)

    # Update a record in the Books table
    print("Updating the price of the book with BookID = 3 to 19.99")
    update_query = "UPDATE Books SET price = %s WHERE BookID = %s"
    data = (19.99, 3)
    cursor.execute(update_query, data)
    conn.commit()
    print("Record updated successfully")

    # Fetch updated data to verify the update
    print("Fetching updated data to verify the update:")
    cursor.execute("SELECT * FROM Books WHERE BookID = 3")
    updated_row = cursor.fetchone()
    print(updated_row)

    # Delete a record from the Books table
    print("Deleting the book with BookID = 5")
    delete_query = "DELETE FROM Books WHERE BookID = %s"
    book_id_to_delete = (5,)
    cursor.execute(delete_query, book_id_to_delete)
    conn.commit()
    print("Record deleted successfully")

    # Fetch remaining data to verify the deletion
    print("Fetching remaining data from the Books table:")
    cursor.execute("SELECT * FROM Books")
    remaining_rows = cursor.fetchall()
    for row in remaining_rows:
        print(row)

except Error as e:
    print(f"Error: {e}")

finally:
    if conn.is_connected():
        cursor.close()
        conn.close()
        print("MySQL connection is closed")
