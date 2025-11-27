using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.SqlClient;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace eStore
{

    public partial class Dashboard : System.Web.UI.Page
    {
        SqlConnection con = dbConfig.GetCon();
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)     // VERY IMPORTANT
            {
                fetchCategories();
               fetchProduct();
                updateUnitPrice();
            }

        }
        void updateUnitPrice()
        {
            SqlCommand cmd = new SqlCommand("retUnitPrice", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@p", DropDownList2.SelectedValue);
            cmd.Parameters.AddWithValue("@c", DropDownList1.SelectedValue);
            con.Open();
            object result = cmd.ExecuteScalar();
            Label1.Text = result.ToString();
            con.Close();
        }

        void fetchCategories()
        {
            DropDownList1.Items.Clear();

            SqlCommand cmd = new SqlCommand("fetchCategory", con);
            cmd.CommandType = CommandType.StoredProcedure;

            con.Open();
            SqlDataReader rdr = cmd.ExecuteReader();

            while (rdr.Read())
            {
                DropDownList1.Items.Add(rdr["category"].ToString());
            }

            con.Close();
        }

        void fetchProduct()
        {
            DropDownList2.Items.Clear();

            SqlCommand cmd = new SqlCommand("fetchProduct", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@c", DropDownList1.SelectedValue);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            while (dr.Read())
            {
                DropDownList2.Items.Add(dr["ProductName"].ToString());
            }

            con.Close();
        }
        protected void Button2_Click(object sender, EventArgs e)
        {
            Response.Redirect("Cart.aspx");
        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            string category = DropDownList1.SelectedValue;
            string product = DropDownList2.SelectedValue;
            string qty = TextBox1.Text;
            string unitPrice = Label1.Text;

            string item = category + "|" + product + "|" + qty + "|" + unitPrice + "$";

            // Always read from the request first
            string oldCart = "";

            if (Request.Cookies["cart"] != null)
            {
                oldCart = Request.Cookies["cart"].Value;
            }

            // Append new item to old data
            string newCart = oldCart + item;

            // Write back to the response cookie
            HttpCookie cartCookie = new HttpCookie("cart");
            cartCookie.Value = newCart;
            cartCookie.Expires = DateTime.Now.AddDays(7);

            Response.Cookies.Add(cartCookie);
        }


        protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
        {
            fetchProduct();
        }

        protected void DropDownList2_SelectedIndexChanged(object sender, EventArgs e)
        {
            updateUnitPrice();
        }
    }
}