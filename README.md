# expa_automator_mk2
Project done as part of my work as <i>National Exchange Director</i> for <i>AIESEC in Singapore</i>

This project aims to reduce workload of my Outgoing Exchange team through eliminating the need for manual data entry. Previously, this was done by manually checking our global CRM / information system (nicknamed EXPA) for information on our customers (commonly referred to as exchange participants or EPs), and entering the related numbers in a spreadsheet for performance tracking.

Data is structured in NoSQL and can be obtained the EXPA API. The code extracts all sign-ups within a specified date range, and processes it to keep only the fields relevant to our daily processes e.g. name, contact information, 

This is useful for extracting large amounts of customer data at one go, typically for periodic reviews, as the EXPA front-end isn't particularly fast - it can write the output into a CSV file for easier readibility.

Note:
<br> EXPA data is restricted to AIESEC members only, hence a developer token is required. If you are an AIESEC member looking to automate your processes, please refer to this [link](https://expa.aiesec.org/resource-center/pages/830) to get a token for yourself (AIESEC login required). Do note that the access permissions of your token is the same as that of your AIESEC account (e.g. you will only be able to access data of sign-ups for your entire country if you are a country-level manager).

This is an improved version of the [previous iteration](https://github.com/kaiwei-tan/expa_automator_mk1), done in Python.
