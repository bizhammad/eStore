# eStore - ASP.NET Web Forms E-Commerce Project

## Introduction

eStore is a robust, simple e-commerce web application built using ASP.NET Web Forms and SQL Server. This project serves as a demonstration of core e-commerce functionalities, including product browsing, cart management, secure order placement, and history tracking. It combines classic ADO.NET data access patterns (using Stored Procedures) with a responsive user interface powered by Bootstrap 5.

## Tech Stack

- Framework: .NET Framework 4.5+ (ASP.NET Web Forms)
- Language: C#
- Frontend: HTML5, CSS3, Bootstrap 4
- Database: SQL Server (Express or Full)
- Data Access: ADO.NET with Stored Procedures
- IDE: Visual Studio 2015 or higher


## Features

### User Features
- 🔐 Authentication: Secure Login and Logout functionality with credential validation via stored procedures.
- 📦 Product Browsing: View inventory organized by categories.
- 🛒 Shopping Cart: Add multiple items, manage quantities, and review totals before checkout.
- 💳 Order Placement: Seamless checkout process creating records in Order and Sales tables.
- 📜 Order History: Grid view of all past orders placed by the logged-in user.
- 📄 Order Details: Deep-dive into specific orders to view status, dates, and item breakdowns.
- 🛡️ Security: Role-based logic ensures users can only access their own order data. Unauthorized access attempts trigger alerts.

### Developer Features

- Clean Database Layer: All database logic is encapsulated in Stored Procedures for security and performance.
- Centralized Config: Database connections are managed via a static dbConfig.cs file.
- Responsive UI: Full use of Bootstrap grids, tables, and components for mobile-friendly layouts.
- SQL Scripts Included: Complete setup.sql provided to generate the schema, relations, and types.

## ⚙️ How It Works

- Authentication: Users validate against the Users table via the validateUser stored procedure.
- Cart Management: Items selected from Inventory are held in session/memory until the user decides to checkout.
- Order Processing:
    - A primary record is created in the Order table.
    - Individual items are batch inserted into the Sales table using the CreateOrderWithSales stored procedure.
- Data Integrity: Foreign keys link Sales $\rightarrow$ Orders $\rightarrow$ Users.
- Retrieval: The fetchOrders procedure retrieves history. Viewing details uses query strings (e.g., ?OrderID=10), with backend logic verifying ownership before rendering.



### Prerequisites
    1. Visual Studio 2015+
    2. SQL Server (LocalDB, Express, or Full)
    3. Git

## Installation

Follow these steps to install eStore:

1. Clone the repository:
   ```bash
   git clone https://github.com/bizhammad/eStore.git
   cd eStore
   ```
2. Database Configuration
    - Open SQL Server Management Studio (SSMS).
    - Locate the database script. It is located at:eStore/eStore/App_Data/setup.sql
    - Execute the script to create:
        - Database: eStore
        - Tables: Users, Inventory, Order, Sales
        - Types: CartItemType (for Table-Valued Parameters)
        - Stored Procedures: CreateOrder, fetchOrders, etc.
3. Update Connection String
   - Open dbConfig.cs and ensure the connection string matches your SQL Server instance:
   ```bash
   public static SqlConnection con = new SqlConnection(
    @"Data Source=localhost\SQLEXPRESS;Initial Catalog=eStore;Integrated Security=True;TrustServerCertificate=True"
    );
   ```
   Note: Update Data Source to your server name if it is different  from localhost\SQLEXPRESS.

4. Restore Packages & Run
    - Open eStore.sln in Visual Studio.
    - Go to Tools -> NuGet Package Manager  ->  Manage NuGet Packages for Solution.
    - Click Restore to download missing dependencies.
    - Press F5 or Ctrl+F5 to run the application.
    - Navigate to Login.aspx.

## Database
    - setup.sql file : eStore/App_Data/setup.sql

## 🔒 Security Notes

- Data Isolation: Logic is implemented to prevent IDOR (Insecure Direct Object Reference). Users cannot view order IDs that do not belong to them.
- SQL Injection: The use of Stored Procedures and parameterized queries mitigates SQL injection risks.
- Production Warning: Never expose connection strings in source code for production environments. Use Web.config with encryption or Environment Variables.

## Contributing

We welcome contributions from the community! To contribute:

- Fork the repository and create your feature branch.
- Ensure code follows the existing style and passes all tests.
- Submit a pull request with a descriptive message.
- Address any review comments from project maintainers.

For larger changes, please open an issue first to discuss your proposal.

## License

This project is licensed under the MIT License. See the `LICENSE` file for details.
GitHub Repository: https://github.com/bizhammad/eStore

---



