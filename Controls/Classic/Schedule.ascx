<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="Schedule.ascx.cs" Inherits="AgentSite4.Controls.Schedule" %>
<contenttemplate>

    <center>
        <table border="0" cellpadding="0" cellspacing="0" id="PageRefresh">
            <tr>
                <td id="TBTitle"><%=SportTitle%></td>
                <td align="right">
                    <input type="text" name="txtFind" value="" size="20" />
                    <input type="button" onclick="FindStr();" value="Find" name="bFind" />
                    <input type="button" onclick="PageReload();" value="Refresh" />
                </td>
                <td style="width: 5px;"></td>
            </tr>
        </table>
        <table border="0" cellpadding="0" cellspacing="0" id="TBComboSchedule">
            <tr>
                <td>League:
                    <asp:DropDownList CssClass="form-control form-control-sm tomlist" runat="server" ID="cmbLeague"></asp:DropDownList>
                </td>
                <td>Display:
                    <asp:DropDownList CssClass="form-control form-control-sm tomlist" runat="server" ID="cmbDisplay"></asp:DropDownList>
                </td>
                <td>Order:
                    <asp:DropDownList CssClass="form-control form-control-sm tomlist" runat="server" ID="cmbOrder"></asp:DropDownList>
                </td>
                <td>Event:
                    <asp:DropDownList CssClass="form-control form-control-sm tomlist" runat="server" ID="cmbEvent"></asp:DropDownList>
                </td>
            </tr>
        </table>

        <%if (IdSport == "NFL" || IdSport == "CBB" || IdSport == "NBA" || IdSport == "CFB")
            { %>
        <asp:DataGrid ID="sDGridFB"
            runat="server"
            OnEditCommand="EditEvent"
            OnCancelCommand="CancelEvent"
            OnUpdateCommand="UpdateEvent"
            AutoGenerateColumns="false"
            HeaderStyle-HorizontalAlign="Center"
            HeaderStyle-BackColor="#0099FF"
            HeaderStyle-ForeColor="#FFFFFF"
            HeaderStyle-Font-Bold="True"
            HeaderStyle-BorderWidth="1px"
            HeaderStyle-BorderColor="#000000"
            AlternatingItemStyle-BackColor="#C5E7F6"
            Width="840px"
            BorderWidth="1px"
            BorderColor="#000000"
            CssClass="ScheduleCss"
            BackColor="#F9FDFD"
            GridLines="Both">
            <Columns>
                <asp:TemplateColumn HeaderText="D/T">
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem,"D/T") %>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="#">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "#")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Team Name">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Team Name")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Spread">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Sprd")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtsprd" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Sprd")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Spread <br/> Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "sOdds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtsodds" runat="server" Width="40px" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "sOdds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Spread <br/> Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "sAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Total")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txttotal" runat="server" Width="40px" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total <br/> Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "tOdds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txttodds" runat="server" Width="40px" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "tOdds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total <br/> Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "tAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="$-Line">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "$-Line")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox ID="txtmline" runat="server" Width="40px" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "$-Line")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action <br/> $-Line">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Action")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Type" ItemStyle-CssClass="TextRight">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "*")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:EditCommandColumn EditText="<img src='../App_Themes/Classic/images/Edit.gif' width='30' height='30' border='0' alt='Edit' />"
                    CancelText="<img src='../App_Themes/Classic/images/Cancel.gif' width='30' height='30' border='0' alt='Cancel' />"
                    UpdateText="<img src='../App_Themes/Classic/images/Update.gif' width='30' height='30' border='0' alt='Update' />" />
            </Columns>
        </asp:DataGrid>
        <%}
            else if (IdSport == "SOC" || IdSport == "MU")
            {%>
        <asp:DataGrid ID="sDGridSM"
            runat="server"
            OnEditCommand="EditEvent"
            OnCancelCommand="CancelEvent"
            OnUpdateCommand="UpdateEvent"
            AutoGenerateColumns="false"
            HeaderStyle-HorizontalAlign="Center"
            HeaderStyle-BackColor="#0099FF"
            HeaderStyle-ForeColor="#FFFFFF"
            HeaderStyle-Font-Bold="True"
            HeaderStyle-BorderWidth="1px"
            HeaderStyle-BorderColor="#000000"
            AlternatingItemStyle-BackColor="#C5E7F6"
            Width="840px"
            BorderWidth="1px"
            BorderColor="#000000"
            CssClass="ScheduleCss"
            BackColor="#F9FDFD"
            GridLines="Both">
            <Columns>
                <asp:TemplateColumn HeaderText="D/T">
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem,"D/T") %>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="#">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "#")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Team Name">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Team Name")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="$-Ln">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "$-Ln")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtLn" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "$-Ln")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="$-Ln<br/>Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "lnAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Total")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtTotal" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total<br/>Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Total_Odds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtTotalOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Total_Odds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "oAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Spread<br/>Goals">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Sprd/Goals")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtSprdGoals" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Sprd/Goals")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Odds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Odds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Action")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Type" ItemStyle-CssClass="TextRight">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "*")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:EditCommandColumn EditText="<img src='../App_Themes/Classic/images/Edit.gif' width='30' height='30' border='0' alt='Edit' />"
                    CancelText="<img src='../App_Themes/Classic/images/Cancel.gif' width='30' height='30' border='0' alt='Cancel' />"
                    UpdateText="<img src='../App_Themes/Classic/images/Update.gif' width='30' height='30' border='0' alt='Update' />" />
            </Columns>
        </asp:DataGrid>
        <%}
            else if (IdSport == "MLB")
            {%>
        <asp:DataGrid ID="sDGridM"
            runat="server"
            OnEditCommand="EditEvent"
            OnCancelCommand="CancelEvent"
            OnUpdateCommand="UpdateEvent"
            AutoGenerateColumns="false"
            HeaderStyle-HorizontalAlign="Center"
            HeaderStyle-BackColor="#0099FF"
            HeaderStyle-ForeColor="#FFFFFF"
            HeaderStyle-Font-Bold="True"
            HeaderStyle-BorderWidth="1px"
            HeaderStyle-BorderColor="#000000"
            AlternatingItemStyle-BackColor="#C5E7F6"
            Width="840px"
            BorderWidth="1px"
            BorderColor="#000000"
            CssClass="ScheduleCss"
            BackColor="#F9FDFD"
            GridLines="Both">
            <Columns>

                <asp:TemplateColumn HeaderText="D/T">
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem,"D/T") %>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="#">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "#")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Team Name">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Team Name")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Pitcher">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Pitcher")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="$-Ln">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "$-Ln")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtLn" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "$-Ln")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="$-Ln<br/>Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "mlAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Total")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtTotal" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Odds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Odds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total<br/>Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "tAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="R-L">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "R-L")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtRL" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "R-L")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "rlOdds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtrlOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "rlOdds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="R-L<br/>Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "rlAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Type" ItemStyle-CssClass="TextRight">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "*")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:EditCommandColumn EditText="<img src='../App_Themes/Classic/images/Edit.gif' width='30' height='30' border='0' alt='Edit' />"
                    CancelText="<img src='../App_Themes/Classic/images/Cancel.gif' width='30' height='30' border='0' alt='Cancel' />"
                    UpdateText="<img src='../App_Themes/Classic/images/Update.gif' width='30' height='30' border='0' alt='Update' />" />

            </Columns>
        </asp:DataGrid>
        <%}
            else if (IdSport == "NHL")
            {%>
        <asp:DataGrid ID="sDGridN"
            runat="server"
            OnEditCommand="EditEvent"
            OnCancelCommand="CancelEvent"
            OnUpdateCommand="UpdateEvent"
            AutoGenerateColumns="false"
            HeaderStyle-HorizontalAlign="Center"
            HeaderStyle-BackColor="#0099FF"
            HeaderStyle-ForeColor="#FFFFFF"
            HeaderStyle-Font-Bold="True"
            HeaderStyle-BorderWidth="1px"
            HeaderStyle-BorderColor="#000000"
            AlternatingItemStyle-BackColor="#C5E7F6"
            Width="840px"
            BorderWidth="1px"
            BorderColor="#000000"
            CssClass="ScheduleCss"
            BackColor="#F9FDFD"
            GridLines="Both">
            <Columns>

                <asp:TemplateColumn HeaderText="D/T">
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem,"D/T") %>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="#">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "#")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Team Name">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Team Name")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="$-Ln">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "$-Ln")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtLn" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "$-Ln")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="$-Ln<br/>Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "mlAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="Total">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Total")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtTotal" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Total")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Odds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Odds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Total<br/>Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "tAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="C-L">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "C_L")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtCL" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "C_L")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "clOdds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtclOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "clOdds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="A-L">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "A_L")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtAL" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "A_L")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "alOdds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtalOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "alOdds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Action")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Type" ItemStyle-CssClass="TextRight">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "*")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:EditCommandColumn EditText="<img src='../App_Themes/Classic/images/Edit.gif' width='30' height='30' border='0' alt='Edit' />"
                    CancelText="<img src='../App_Themes/Classic/images/Cancel.gif' width='30' height='30' border='0' alt='Cancel' />"
                    UpdateText="<img src='../App_Themes/Classic/images/Update.gif' width='30' height='30' border='0' alt='Update' />" />

            </Columns>
        </asp:DataGrid>

        <%}
            else if (IdSport == "TNT")
            {%>
        <asp:DataGrid ID="sDGridT"
            runat="server"
            OnEditCommand="EditEvent"
            OnCancelCommand="CancelEvent"
            OnUpdateCommand="UpdateEvent"
            AutoGenerateColumns="false"
            HeaderStyle-HorizontalAlign="Center"
            HeaderStyle-BackColor="#0099FF"
            HeaderStyle-ForeColor="#FFFFFF"
            HeaderStyle-Font-Bold="True"
            HeaderStyle-BorderWidth="1px"
            HeaderStyle-BorderColor="#000000"
            AlternatingItemStyle-BackColor="#C5E7F6"
            Width="840px"
            BorderWidth="1px"
            BorderColor="#000000"
            CssClass="ScheduleCss"
            BackColor="#F9FDFD"
            GridLines="Both">
            <Columns>

                <asp:TemplateColumn HeaderText="CutOff">
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem, "CutOff")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="#">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "#")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Description">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Description")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Odds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Odds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Action")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="LastUpdate">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "LastUpdate")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Type" ItemStyle-CssClass="TextRight">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "*")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:EditCommandColumn EditText="<img src='../App_Themes/Classic/images/Edit.gif' width='30' height='30' border='0' alt='Edit' />"
                    CancelText="<img src='../App_Themes/Classic/images/Cancel.gif' width='30' height='30' border='0' alt='Cancel' />"
                    UpdateText="<img src='../App_Themes/Classic/images/Update.gif' width='30' height='30' border='0' alt='Update' />" />

            </Columns>
        </asp:DataGrid>

        <%}
            else if (IdSport == "PROP")
            {%>
        <asp:DataGrid ID="sDGridP"
            runat="server"
            OnEditCommand="EditEvent"
            OnCancelCommand="CancelEvent"
            OnUpdateCommand="UpdateEvent"
            AutoGenerateColumns="false"
            HeaderStyle-HorizontalAlign="Center"
            HeaderStyle-BackColor="#0099FF"
            HeaderStyle-ForeColor="#FFFFFF"
            HeaderStyle-Font-Bold="True"
            HeaderStyle-BorderWidth="1px"
            HeaderStyle-BorderColor="#000000"
            AlternatingItemStyle-BackColor="#C5E7F6"
            Width="840px"
            BorderWidth="1px"
            BorderColor="#000000"
            CssClass="ScheduleCss"
            BackColor="#F9FDFD"
            GridLines="Both">
            <Columns>

                <asp:TemplateColumn HeaderText="CutOff">
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem, "CutOff")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="#">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "#")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Prop Type">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Prop Type")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Description">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Description")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="Odds">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Odds")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtOdds" CssClass="ChartTB"
                            Text='<%#DataBinder.Eval(Container.DataItem, "Odds")%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Action")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:EditCommandColumn EditText="<img src='../App_Themes/Classic/images/Edit.gif' width='30' height='30' border='0' alt='Edit' />"
                    CancelText="<img src='../App_Themes/Classic/images/Cancel.gif' width='30' height='30' border='0' alt='Cancel' />"
                    UpdateText="<img src='../App_Themes/Classic/images/Update.gif' width='30' height='30' border='0' alt='Update' />" />

            </Columns>
        </asp:DataGrid>

        <%}
            else if (IdSport == "ESOC")
            {%>
        <asp:DataGrid ID="sDGridE"
            runat="server"
            OnEditCommand="EditEvent"
            OnCancelCommand="CancelEvent"
            OnUpdateCommand="UpdateEvent"
            AutoGenerateColumns="false"
            HeaderStyle-HorizontalAlign="Center"
            HeaderStyle-BackColor="#0099FF"
            HeaderStyle-ForeColor="#FFFFFF"
            HeaderStyle-Font-Bold="True"
            HeaderStyle-BorderWidth="1px"
            HeaderStyle-BorderColor="#000000"
            AlternatingItemStyle-BackColor="#C5E7F6"
            Width="840px"
            BorderWidth="1px"
            BorderColor="#000000"
            CssClass="ScheduleCss"
            BackColor="#F9FDFD"
            GridLines="Both">
            <Columns>

                <asp:TemplateColumn HeaderText="D/T">
                    <ItemTemplate>
                        <%# DataBinder.Eval(Container.DataItem,"D/T") %>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="#">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "#")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Teams Name">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Teams")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="Home">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Home")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txthome" CssClass="ChartTB"
                            Text='<%# String.Format("{0:0}",decimal.Parse(DataBinder.Eval(Container.DataItem, "Home").ToString()))%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "hAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="Draw">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Draw")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtDraw" CssClass="ChartTB"
                            Text='<%# String.Format("{0:0}",decimal.Parse(DataBinder.Eval(Container.DataItem, "Draw").ToString()))%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "dAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="Visitor">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "Visitor")%>
                    </ItemTemplate>
                    <EditItemTemplate>
                        <asp:TextBox runat="server" Width="40px" ID="txtVisitor" CssClass="ChartTB"
                            Text='<%# String.Format("{0:0}",decimal.Parse(DataBinder.Eval(Container.DataItem, "Visitor").ToString()))%>' />
                    </EditItemTemplate>
                </asp:TemplateColumn>
                <asp:TemplateColumn HeaderText="Action">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "vAction")%>
                    </ItemTemplate>
                </asp:TemplateColumn>

                <asp:TemplateColumn HeaderText="Type" ItemStyle-CssClass="TextRight">
                    <ItemTemplate>
                        <%#DataBinder.Eval(Container.DataItem, "*")%>
                    </ItemTemplate>
                </asp:TemplateColumn>
                <asp:EditCommandColumn EditText="<img src='../App_Themes/Classic/images/Edit.gif' width='30' height='30' border='0' alt='Edit' />"
                    CancelText="<img src='../App_Themes/Classic/images/Cancel.gif' width='30' height='30' border='0' alt='Cancel' />"
                    UpdateText="<img src='../App_Themes/Classic/images/Update.gif' width='30' height='30' border='0' alt='Update' />" />


            </Columns>
        </asp:DataGrid>
        <%} %>
        <br />
    </center>

</contenttemplate>
