using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


namespace eStore
{
    public partial class Login : System.Web.UI.Page
    {
        SqlConnection con = dbConfig.GetCon();
        protected void Page_Load(object sender, EventArgs e)
        {
            if(Session["Username"]!=null)
            {
                Response.Redirect("Dashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            SqlCommand cmd = new SqlCommand("validateUser", con);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.AddWithValue("@u", txtUsername.Text);
            cmd.Parameters.AddWithValue("@p", txtPassword.Text);


            con.Open();
            int result = Convert.ToInt32(cmd.ExecuteScalar());

            if (result == 1)
            {
                Session["Username"] = txtUsername.Text;
                Response.Redirect("Dashboard.aspx");
            }
            else
            {
                Label1.Text = "Invalid Username Or Password";
            }
        }
    }
}