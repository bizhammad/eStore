using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;


namespace eStore
{
    public static class dbConfig
    {
        public static SqlConnection GetCon()
        {
            return new SqlConnection(
                ConfigurationManager.ConnectionStrings["eStoreCon"].ConnectionString
            );
        }
    }
}