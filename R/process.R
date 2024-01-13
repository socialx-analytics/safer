#' Process Rows in SAFER Database
#'
#' This function processes rows with NA labels in a specified table within a SQLite database.
#' It repeatedly selects a row with NA label, applies a user-defined function to it, and updates the row in the database.
#'
#' @param db_name Name of the SQLite database file. Default is "safer.sqlite".
#' @param table_name Name of the table within the database. Default is "safer_table".
#' @param .f A user-defined function to process the text column in each row.
#' @return None
#' @export
#' @examples
#' \dontrun{
#' process(con = NULL, .f = your_processing_function)
#' }
process <- function(db_name = "safer.sqlite", table_name = "safer_table", .f) {

  # Establish database connection if not provided
  con <- DBI::dbConnect(RSQLite::SQLite(), dbname = db_name)

  repeat {
    # Count rows with NA label
    na_count <- DBI::dbGetQuery(con, glue::glue("SELECT COUNT(*) as count FROM {table_name} WHERE label IS NULL"))
    message("Jumlah baris dengan label NA: ", na_count$count, "\n")

    # Exit loop if no NA labels are found
    if (na_count$count == 0) {
      message("All data successfully processed.")
      break
    }

    # Retrieve a row with NA label
    row_to_process <- DBI::dbGetQuery(con, glue::glue("SELECT * FROM {table_name} WHERE label IS NULL LIMIT 1"))

    # Process the retrieved row
    tryCatch(
      {
        transformed_text <- .f(row_to_process$text)
        # Update the processed row in the database
        DBI::dbExecute(con, sprintf("UPDATE {table_name} SET label = '%s' WHERE id = %d", transformed_text, row_to_process$id))
      },
      error = function(e) {
        message("Error occurred: ", e)
      }
    )
  }

  # Disconnect from the database
  DBI::dbDisconnect(con)
}
