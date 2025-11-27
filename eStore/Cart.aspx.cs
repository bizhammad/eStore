using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace eStore
{
    public partial class Cart : System.Web.UI.Page
    { 

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadCart();
                decimal total = 0;

                foreach (GridViewRow row in GridView1.Rows)
                {
                    // Parse the value in the Amount column (adjust index)
                    decimal amount = 0;
                    decimal.TryParse(row.Cells[4].Text, out amount);
                    total += amount;
                }

                // Display in Label1
                Label1.Text = total.ToString("N2");
            }
        }
        private void LoadCart()
        {
            DataTable dt = new DataTable();
            dt.Columns.Add("Category");
            dt.Columns.Add("Product");
            dt.Columns.Add("Qty");
            dt.Columns.Add("UnitPrice");
            dt.Columns.Add("Total");

            string raw = Request.Cookies["cart"]?.Value;

            if (!string.IsNullOrEmpty(raw))
            {
                string[] items = raw.Split('$');

                foreach (string record in items)
                {
                    if (string.IsNullOrWhiteSpace(record)) continue;

                    string[] parts = record.Split('|');

                    string category = parts[0];
                    string product = parts[1];
                    string qty = parts[2];
                    string unitPrice = parts[3];

                    decimal total = Convert.ToDecimal(qty) * Convert.ToDecimal(unitPrice);

                    dt.Rows.Add(category, product, qty, unitPrice, total);
                }
            }

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            // 1. Create a DataTable matching CartItemType
            DataTable cartTable = new DataTable();
            cartTable.Columns.Add("ProductName", typeof(string));
            cartTable.Columns.Add("Category", typeof(string));
            cartTable.Columns.Add("Quantity", typeof(int));
            cartTable.Columns.Add("UnitPrice", typeof(decimal));

            // 2. Fill DataTable from GridView1 (your cart)
            foreach (GridViewRow row in GridView1.Rows)
            {
                cartTable.Rows.Add(
                    row.Cells[1].Text,               // ProductName
                    row.Cells[0].Text,               // Category
                    int.Parse(row.Cells[2].Text),    // Quantity
                    decimal.Parse(row.Cells[3].Text) // UnitPrice
                );
            }
            
            // 3. Call the stored procedure
            int newOrderId = 0;
            using (SqlConnection con = dbConfig.GetCon())
            {
                SqlCommand cmd = new SqlCommand("CreateOrderWithSales", con);
                cmd.CommandType = CommandType.StoredProcedure;

                // Input parameters
                cmd.Parameters.AddWithValue("@Username", Session["Username"]);

                SqlParameter tvpParam = cmd.Parameters.AddWithValue("@CartItems", cartTable);
                tvpParam.SqlDbType = SqlDbType.Structured;
                tvpParam.TypeName = "CartItemType"; // Must match the SQL type name

                // Output parameter
                SqlParameter outputId = new SqlParameter("@NewOrderID", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                cmd.Parameters.Add(outputId);

                con.Open();
                cmd.ExecuteNonQuery();
                newOrderId = (int)outputId.Value;
            }

            // 4. Optional: Clear cart cookie
            Response.Cookies["cart"].Expires = DateTime.Now.AddDays(-1);

            // 5. Redirect to confirmation page
            Response.Redirect("Orders.aspx?OrderID=" + newOrderId);
            
            




        }
    }
}