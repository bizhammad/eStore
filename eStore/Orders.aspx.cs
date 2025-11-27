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
    public partial class Orders : System.Web.UI.Page
    {
        SqlConnection con = dbConfig.GetCon();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string orderIdStr = Request.QueryString["OrderID"];
                if (!string.IsNullOrEmpty(orderIdStr))
                {
                    int orderId = Convert.ToInt32(orderIdStr);

                    // Check if order belongs to logged-in user
                    SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM [Order] WHERE OrderID=@orderId AND Username=@user", con);
                    checkCmd.Parameters.AddWithValue("@orderId", orderId);
                    checkCmd.Parameters.AddWithValue("@user", Session["Username"].ToString());

                    con.Open();
                    int count = (int)checkCmd.ExecuteScalar();
                    con.Close();

                    if (count == 0)
                    {
                        // Order doesn't belong to user
                        string script = "alert('Access Denied!'); window.location='Orders.aspx';";
                        ClientScript.RegisterStartupScript(this.GetType(), "AccessDenied", script, true);
                        return;
                    }

                    // Show order summary and products
                    pnlOrderDetails.Visible = true;
                    BindOrderSummary(orderId);
                    ShowOrderDetails(orderId);

                    // Hide View Details buttons
                    foreach (GridViewRow row in GridView1.Rows)
                    {
                        Button btn = (Button)row.FindControl("btnView");
                        if (btn != null)
                            btn.Visible = false;
                    }
                }
                else
                {
                    // Show all orders
                    fetchOrders();
                }
            }
        }

        private void BindOrderSummary(int orderId)
        {
            SqlCommand cmd = new SqlCommand(@"SELECT o.OrderID, o.Username, o.OrderStatus, o.OrderDateTime, 
                                     SUM(s.Amount) AS TotalAmount
                                     FROM [Order] o
                                     INNER JOIN Sales s ON o.OrderID = s.OrderID
                                     WHERE o.OrderID = @orderId
                                     GROUP BY o.OrderID, o.Username, o.OrderStatus, o.OrderDateTime", con);
            cmd.Parameters.AddWithValue("@orderId", orderId);
            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();
            if (dr.Read())
            {
                lblOrderID.Text = dr["OrderID"].ToString();
                lblUsername.Text = dr["Username"].ToString();
                lblOrderStatus.Text = dr["OrderStatus"].ToString();
                lblOrderDate.Text = Convert.ToDateTime(dr["OrderDateTime"]).ToString("dd MMM yyyy HH:mm");
                lblOrderTotal.Text = dr["TotalAmount"].ToString();
            }
            con.Close();
        }


        protected void btnBack_Click(object sender, EventArgs e)
        {
            Response.Redirect("Orders.aspx");
        }



        void fetchOrders()
        {
            SqlCommand cmd = new SqlCommand("fetchOrders", con);
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Parameters.AddWithValue("@user", Session["Username"]);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();

            da.Fill(dt);
            GridView1.DataSource = dt;
            GridView1.DataBind();
        }

        protected void GridView1_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
        protected void GridView1_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "ViewOrder")
            {
                int rowIndex = Convert.ToInt32(e.CommandArgument);
                GridViewRow row = GridView1.Rows[rowIndex];

                string orderId = row.Cells[1].Text; // First auto-generated column is OrderID
                Response.Redirect("Orders.aspx?OrderID=" + orderId);
            }
        }
        void ShowOrderDetails(int orderId)
        {
            string query = @"SELECT s.ProductID, i.ProductName, i.Category, s.Quantity, s.Amount
                     FROM Sales s
                     INNER JOIN Inventory i ON s.ProductID = i.ID
                     WHERE s.OrderID = @orderId";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@orderId", orderId);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            da.Fill(dt);

            GridView1.DataSource = dt;
            GridView1.DataBind();
        }


        protected void GridView1_SelectedIndexChanged1(object sender, EventArgs e)
        {

        }
    }
}