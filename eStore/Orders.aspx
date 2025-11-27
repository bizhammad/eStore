<%@ Page Title="Orders - eStore" Language="C#" MasterPageFile="~/master.Master" AutoEventWireup="true" CodeBehind="Orders.aspx.cs" Inherits="eStore.Orders" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <asp:Panel ID="pnlOrderDetails" runat="server" Visible="false" CssClass="mb-4 p-3 border rounded shadow-sm">
    <h5>Order Details</h5>
    <p><strong>Order ID:</strong> <asp:Label ID="lblOrderID" runat="server"></asp:Label></p>
    <p><strong>Username:</strong> <asp:Label ID="lblUsername" runat="server"></asp:Label></p>
    <p><strong>Order Status:</strong> <asp:Label ID="lblOrderStatus" runat="server"></asp:Label></p>
    <p><strong>Order Date:</strong> <asp:Label ID="lblOrderDate" runat="server"></asp:Label></p>
    <p><strong>Order Total:</strong> <asp:Label ID="lblOrderTotal" runat="server"></asp:Label></p>
    <asp:Button ID="btnBack" runat="server" Text="Back to All Orders" CssClass="btn btn-primary" OnClick="btnBack_Click" />
</asp:Panel>

    <div class="container mt-4">
    <div class="row justify-content-center">
        <asp:GridView 
    ID="GridView1" 
    runat="server" 
    CssClass="table table-striped table-bordered table-hover text-center shadow-sm"
    AutoGenerateColumns="true"
    OnRowCommand="GridView1_RowCommand">
    
    <Columns>
        <asp:TemplateField>
            <ItemTemplate>
                <asp:Button ID="btnView" runat="server" Text="View Details" 
                    CommandName="ViewOrder" 
                    CommandArgument='<%# Container.DataItemIndex %>' 
                    CssClass="btn btn-primary btn-sm" />
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>

        </div>
    </div>
</div>


</asp:Content>
