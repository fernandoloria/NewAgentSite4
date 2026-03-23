<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="PlayerPaymentBulkPayment.aspx.cs" Inherits="AgentSite4.Report.PlayerPaymentBulkPayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">
          <script type="text/javascript" src="https://code.jquery.com/jquery-2.1.4.min.js"></script>
        <SCRIPT LANGUAGE="JavaScript">

            function calculateNewBalance(balance, row, ddlTransactionType, lblNewBalance) {
                var amount = $("#row_" + row + " input[type=text]").val();
                if (amount == "") {
                    amount = 0;
                }

                var transaction = $(ddlTransactionType).val();
                var signo = 1;
                if (transaction == "D") {
                    signo = -1;
                }
                var newBalance = parseFloat(balance) + (parseFloat(amount) * parseFloat(signo));
                if (newBalance == 0) {
                    newBalance = "0.00"
                }
                $(lblNewBalance).text(newBalance);
                //window.alert(transaction + " " + balance + " " + amount);
            }
        </SCRIPT>

        
     
    <h3 class="page-title">
        Clear All Balances
    </h3>
    <ul class="page-breadcrumb breadcrumb">
        <li><i class="fa fa-home"></i><a target="mainFrame" href="../Report/Welcome.aspx">Home</a>
            <i class="fa fa-angle-right"></i></li>
        <li><a href="#">Clear All Balances</a></li>
    </ul>
        <asp:Label ID="error" runat="server" Text=""></asp:Label>
        <asp:RangeValidator ID="RangeValidator1" runat="server"  ErrorMessage="*" 
        ControlToValidate="txtDate"></asp:RangeValidator>
    <table cellspacing="1" cellpadding="1" border="0" class="filter">
        <tr>
            <td>
                Display Options:
            </td>
            <td>
                <asp:DropDownList ID="ddlDisplayOptions" runat="server" AutoPostBack="True" CssClass="form-control form-control-sm tomlist">
                    <asp:ListItem Value="0">Select Options</asp:ListItem>
                    <asp:ListItem Value="1">Display Cero Balances</asp:ListItem>
                    <asp:ListItem Value="2">Positive Balance</asp:ListItem>
                    <asp:ListItem Value="3">Negative Balance</asp:ListItem>
                </asp:DropDownList>
				</td><td>
                Method</td>
            <td>
                <asp:DropDownList ID="ddlPaymentMethodSelect" runat="server" 
                    DataSourceID="SqlDataSource2" DataTextField="PaymentMethod" CssClass="form-control form-control-sm tomlist"
                    DataValueField="IdPaymentMethod" AutoPostBack="True" 
                    onselectedindexchanged="ddlPaymentMethodSelect_SelectedIndexChanged">
                </asp:DropDownList>
            </td>
            <td>
                Transaction Type</td>
            <td>
                <asp:DropDownList ID="ddlTransactionTypeSelect" runat="server" CssClass="form-control form-control-sm tomlist"
                    onselectedindexchanged="ddlTransactionType_SelectedIndexChanged" 
                    AutoPostBack="True" >
                        <asp:ListItem Value="A">ADJUSTMENT</asp:ListItem>
						<asp:ListItem Value="C">ACCRUAL ADJUSTMENT</asp:ListItem>
						<asp:ListItem Value="H">HORSE ADJUSTMENT</asp:ListItem>
						<asp:ListItem Value="D">DISBURSEMENT</asp:ListItem>
						<asp:ListItem Value="R">RECEIPT</asp:ListItem>
						<asp:ListItem Value="P">FREE PLAY</asp:ListItem>
					</asp:DropDownList></td>
            <td>
                <asp:Button ID="btnMakeZeros" runat="server" Text="Put in Zeros" class="btnForm" 
                    onclick="btnMakeZeros_Click"/>
            </td>
        </tr>
        
		</table>
		<table  cellspacing="1" cellpadding="1" border="0" class="filter">
        <tr>
            <td>
                <asp:Label ID="lblTransactionDate" runat="server" Text="Transaction Date:"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtDate" name="txtDate" runat="server" Cssclass="form-control form-control-sm"></asp:TextBox>
                    <a href="#" onclick="JavaScript:cal.select(document.forms[0].ctl00_MainContent_txtDate,'anchor1','yyyy-MM-dd'); return false;"
                        name="anchor2" id="a2">
                        <img src="../App_Themes/Classic/images/calendar2.png" border="0" width="24" />
                    </a>
            </td>
            <td>
                <asp:Label ID="Label2" runat="server" Text="Description"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtDescription" runat="server" Text="Agent Payment" class="form-control form-control-sm" style="background: none;"></asp:TextBox>
            </td>
            <td>
                <asp:Label ID="Label3" runat="server" Text="Reference"></asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtReference" runat="server" Text="" class="form-control form-control-sm" style="background: none;" > </asp:TextBox>
            </td>
            <td>
                <asp:Button ID="btnSumit" style="float:right; margin-right:30px;" runat="server" Text="Bulk Payment" class="btnForm" OnClick="btnSumit_Click" />
            </td>
        </tr>
        
    </table>
    <center class="filter">
        <h4>
            - Player Payment Enhanced (Bulk Payment) -
        <h4>
        <asp:Label ID="lblError" runat="server"></asp:Label>
            <br>
            </center>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
        EnableModelValidation="True"  Width="99%" class="filter table-bordered"
        border="0" ondatabound="GridView1_DataBound">
        <AlternatingRowStyle CssClass="TrGameEven" />
        <Columns>
            <asp:BoundField DataField="Agent" HeaderText="Agent" SortExpression="Agent">  </asp:BoundField>
            <asp:TemplateField HeaderText="Player" SortExpression="Player">
                <ItemTemplate>
                    <asp:HiddenField ID="hdfIdPlayer" runat="server" value='<%# Bind("idPlayer") %>'></asp:HiddenField>
                    <asp:Label ID="Label1" runat="server" Text='<%# Bind("Player") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Amount">
                <ItemTemplate>
                    <asp:TextBox ID="txtAmount" runat="server" placeholder="Transaction Amount"></asp:TextBox>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Method">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-control form-control-sm tomlist"
                        DataSourceID="SqlDataSource1" DataTextField="PaymentMethod" 
                        DataValueField="IdPaymentMethod">
                    </asp:DropDownList>
                    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
                        ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>" 
                        SelectCommand="select * from PAYMENTMETHOD order by PAYMENTMETHOD">
                    </asp:SqlDataSource>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Transaction Type">
                <ItemTemplate>
                    <asp:DropDownList ID="ddlTransactionType" runat="server" CssClass="form-control form-control-sm tomlist">
                        <asp:ListItem Value="A">ADJUSTMENT</asp:ListItem>
						<asp:ListItem Value="C">ACCRUAL ADJUSTMENT</asp:ListItem>
						<asp:ListItem Value="H">HORSE ADJUSTMENT</asp:ListItem>
						<asp:ListItem Value="D">DISBURSEMENT</asp:ListItem>
						<asp:ListItem Value="R">RECEIPT</asp:ListItem>
						<asp:ListItem Value="P">FREE PLAY</asp:ListItem>
					</asp:DropDownList>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Current Balance">
                <ItemTemplate>
                    <asp:Label ID="lblCurrentBalance" runat="server" 
                        Text='<%# Bind("CurrentBalance", "{0:N}") %>'></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="New Balance">
                <ItemTemplate>
                    <asp:Label ID="lblNewBalance" runat="server"></asp:Label>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="creditLimit" HeaderText="Credit Limit" 
                SortExpression="creditLimit" DataFormatString="{0:0.00}" >  </asp:BoundField>
            <asp:BoundField DataField="AmountAtRisk" HeaderText="Amount At Risk" 
                SortExpression="AmountAtRisk" DataFormatString="{0:0.00}">  </asp:BoundField>
            <asp:BoundField DataField="AvailBalance" HeaderText="Avail Balance" 
                SortExpression="AvailBalance" DataFormatString="{0:0.00}">  </asp:BoundField>
            <asp:BoundField DataField="freeplayamount" HeaderText="Free Play" 
                SortExpression="freeplayamount" DataFormatString="{0:0.00}">  </asp:BoundField>
           
        </Columns>
        <HeaderStyle CssClass="GameHeader" />
        <RowStyle CssClass="TrGameOdd " />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_PlayerTransation_BulkPayment" 
            SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="" Name="prmIDAgent" 
                SessionField="SubIdAgent" Type="Int32" />
            <asp:ControlParameter ControlID="ddlDisplayOptions" 
                Name="prmDisplayOptions" PropertyName="SelectedValue" Type="Byte" />
        </SelectParameters>
    </asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource2" runat="server" 
        ConnectionString="<%$ ConnectionStrings:DGSDATAConnectionString %>" 
        SelectCommand="select * from PAYMENTMETHOD order by PAYMENTMETHOD">
    </asp:SqlDataSource>
    </div>
</asp:Content>
