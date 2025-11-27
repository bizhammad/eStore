<%@ Page Title="Dashboard - eStore" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="Dashboard.aspx.cs" Inherits="eStore.Dashboard" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="container mt-4">
    <div class="card shadow-sm p-4" style="max-width: 500px; margin:auto;">
        <h4 class="mb-3 text-center">Order Panel</h4>

        <div class="mb-3">
            <label class="form-label">Category</label>
            <asp:DropDownList ID="DropDownList1" CssClass="form-select" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList1_SelectedIndexChanged"></asp:DropDownList>
        </div>

        <div class="mb-3">
            <label class="form-label">Product</label>
            <asp:DropDownList ID="DropDownList2" CssClass="form-select" runat="server" AutoPostBack="True" OnSelectedIndexChanged="DropDownList2_SelectedIndexChanged"></asp:DropDownList>
            <label class="form-label">Unit Price:</label><asp:Label ID="Label1" runat="server"></asp:Label>
        </div>

        <div class="mb-3">
            <label class="form-label">Quantity</label>
            <asp:TextBox ID="TextBox1" CssClass="form-control" runat="server" placeholder="Enter quantity" TextMode="Number">
</asp:TextBox>
        </div>

        <div class="d-flex justify-content-between">
            <asp:Button ID="Button1" runat="server" Text="Add To Cart" CssClass="btn btn-primary" OnClick="Button1_Click" />
            <asp:Button ID="Button2" runat="server" Text="View Cart" CssClass="btn btn-success" OnClick="Button2_Click" />
        </div>
    </div>
</div>

</asp:Content>
