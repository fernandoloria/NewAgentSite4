<%@ Control Language="C#" AutoEventWireup="true" CodeBehind="MenuButtonDashboard.ascx.cs" Inherits="AgentSite4.Controls.MenuButtonDashboard" %>
<style>
.dash-btn{
  display:flex;
  flex-direction:column;
  align-items:center;
  justify-content:center;
  text-align:center;
  text-decoration:none;
  border-radius:16px;           
  min-height:116px;             
  padding:14px 12px;
  box-shadow:0 2px 8px rgba(0,0,0,.08);
  border:1px solid rgba(255,255,255,.2);
  transition:transform .06s ease, box-shadow .2s ease, filter .2s ease;
}
.dash-btn:hover{
  text-decoration:none;
  transform:translateY(-1px);
  box-shadow:0 8px 18px rgba(0,0,0,.12);
  filter:brightness(1.03);
}
.dash-btn .dash-icon{
  line-height:1;
  margin-bottom:8px;
  opacity:.95;                  
}
.dash-btn .dash-label{
  font-weight:600;
  font-size:16px;
  line-height:1.1;
  letter-spacing:.2px;
  max-width:100%;
  display:block;
  word-break:break-word;
}

.dash-btn i{ color:inherit; }

</style>


<div class="row g-3">
  <asp:Repeater ID="filesRepeater" runat="server" OnItemDataBound="filesRepeater_ItemDataBound">
    <ItemTemplate>
      <div class="col-12 col-sm-6 col-md-4 col-lg-3 col-xl-2">
        <a id="lnkReport" runat="server" class="dash-btn w-100">
          <span class="dash-icon">
            <i id="ico" runat="server" class="fa-solid fa-file fa-2xl"></i>
          </span>
          <span id="txt" runat="server" class="dash-label">Report</span>
        </a>
      </div>
    </ItemTemplate>
  </asp:Repeater>
</div>

<br />