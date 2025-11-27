<%@ Page Title="Cart - eStore" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="Cart.aspx.cs" Inherits="eStore.Cart" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <br />
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CssClass="table table-bordered">
    <Columns>
        <asp:BoundField DataField="Category" HeaderText="Category" />
        <asp:BoundField DataField="Product" HeaderText="Product" />
        <asp:BoundField DataField="Qty" HeaderText="Quantity" />
        <asp:BoundField DataField="UnitPrice" HeaderText="Unit Price" />
        <asp:BoundField DataField="Total" HeaderText="Total" />
    </Columns>
</asp:GridView>
    <h4 style="text-align:center; font-weight:500;">
    &nbsp;Grand Total :&nbsp; <asp:Label ID="Label1" runat="server"></asp:Label>
    </h4>
    <br />
    <asp:Button ID="Button1" runat="server" CssClass="btn btn-primary d-block mx-auto mt-3" Text="Place Order" OnClick="Button1_Click" />
    

&nbsp;
    

</asp:Content>
