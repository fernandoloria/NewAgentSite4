<%@ Page Title="" Language="C#" MasterPageFile="~/Master/Classic/Report.Master" AutoEventWireup="true" CodeBehind="AgentDistributionEnhanced.aspx.cs" Inherits="AgentSite4.Report.AgentDistributionEnhanced" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
        <div class="dgsContent">

    <h3 class="page-title">
        Agent Distribution
    </h3>
	<div class="iconset">
			<a href="#" data-toggle="tooltip" title="Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus vestibulum, ante a vehicula porttitor, lectus orci cursus mi, et consequat dui tellus ut mi. Proin id porta orci. Mauris sollicitudin, nunc vel mollis viverra, justo felis dignissim nulla, sed posuere risus sapien vel neque. Nam volutpat ex arcu, vitae vestibulum tortor porttitor posuere. Praesent at diam purus. Sed sit amet mi id sapien congue semper eu non tellus." data-placement="top" data-original-title="Values Online or Phone."><img class="infotool" src="../images/info-icon.png" alt=""/></a>
			<a href="#" data-toggle="modal" data-target="#myModal" ><img class="video" src="../images/play-icon.png" alt=""/></a>
			<span class="css-checkboxspan">
				<input type="checkbox" name="checkboxG2" id="checkboxG2" class="css-checkbox" />
				<label for="checkboxG2" id="labelcheckboxG2" class="css-label"></label>
			</span>
		</div>
     <ul class="page-breadcrumb breadcrumb">
        <li><i class="fa fa-home"></i><a target="mainFrame" href="../Report/Welcome.aspx">Home</a>
            <i class="fa fa-angle-right"></i></li>
        <li><a href="#">Agent Distribution </a></li>
    </ul>
    <table cellspacing="1" cellpadding="1" border="0" class="filter">
        <tr>
            <td>
                Date From:
            </td>
            <td>
                <asp:TextBox ID="txtDateFrom" name="txtDate" runat="server" Cssclass="form-control form-control-sm datepicker"></asp:TextBox>
            </td>
            <td>
                &nbsp;</td>
            <td>
                <a href="#" onclick="JavaScript:cal.select(document.forms[0].ctl00_MainContent_txtDate,'anchor1','yyyy-MM-dd'); return false;"
                    name="anchor2" id="a3">&nbsp;</a></td>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
            <td>
                <asp:Button ID="btnSumit" runat="server" Text="Submit" class="btnForm" OnClick="btnSumit_Click" />
            </td>
        </tr>
        
    </table>
    <center class="filter">
        <h4>
            - Agent Distribution -
            <br>
    </center>
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" DataSourceID="SqlDataSource1"
        EnableModelValidation="True" OnDataBound="GridView1_DataBound" Width="99%" class="filter table-bordered"
        border="0">
        <AlternatingRowStyle CssClass="TrGameEven" />
        <Columns>
            <asp:BoundField DataField="Agent" HeaderText="Agent" SortExpression="Agent">  </asp:BoundField>
            <asp:BoundField DataField="Distributor" HeaderText="Distributor" SortExpression="Distributor">  </asp:BoundField>
            <asp:BoundField DataField="AgentType" HeaderText="AgentType" SortExpression="AgentType" >  </asp:BoundField>
            <asp:BoundField DataField="CommPercent" HeaderText="Comm %" SortExpression="CommPercent" DataFormatString="{0:0}">  </asp:BoundField>
            <asp:BoundField DataField="MakeUp" HeaderText="MakeUp" SortExpression="MakeUp" DataFormatString="{0:0.00}">  </asp:BoundField>
            <asp:BoundField DataField="GrossTW" HeaderText="GrossTW" SortExpression="GrossTW" DataFormatString="{0:0.00}">  </asp:BoundField>
            <asp:BoundField DataField="Gross - MakeUp" HeaderText="Gross - MakeUp" SortExpression="Gross - MakeUp" DataFormatString="{0:0.00}">  </asp:BoundField>
            <asp:BoundField DataField="Comm" HeaderText="Comm" SortExpression="Comm" DataFormatString="{0:0.00}">  </asp:BoundField>
            <asp:BoundField DataField="Dist Week" HeaderText="Dist Week" SortExpression="Dist Week" DataFormatString="{0:0.00}">  </asp:BoundField>
            <asp:BoundField DataField="New MakeUp" HeaderText="New MakeUp" SortExpression="New MakeUp" DataFormatString="{0:0.00}">  </asp:BoundField>
           
        </Columns>
        <HeaderStyle CssClass="GameHeader" />
        <RowStyle CssClass="TrGameOdd " />
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" ConnectionString="<%$ ConnectionStrings:DGS_AddOnsConnectionString %>"
        SelectCommand="AddOn_Service_AgentDistributionByIdAgent" 
            SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter Name="prmIdAgent" SessionField="SubIdAgent" Type="Int32" />
            <asp:ControlParameter ControlID="txtDateFrom" Name="prmDate" PropertyName="Text"
                Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    <h1>
        <asp:Label ID="lblError" runat="server"></asp:Label></h1>
    
    
    </div>
   
</asp:Content>
