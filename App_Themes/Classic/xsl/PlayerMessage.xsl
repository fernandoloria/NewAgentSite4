<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" indent="no" encoding="UTF-8"/>

  <xsl:template match="/*">
    <script language="JavaScript" src="../App_Themes/Classic/CalendarPopup.js"></script>
    <script language="JavaScript">var cal = new CalendarPopup();</script>

    <div class="row page-titles">
      <div class="col-md-5 col-8 align-self-center">
        <h3 class="text-themecolor m-b-0 m-t-0">Player Message</h3>
        <ol class="breadcrumb">
          <li class="breadcrumb-item">
            <a href="../Report/PlayerManagement.aspx" target="_self">Player Message</a>
          </li>
          <li class="breadcrumb-item active">Edit Player</li>
        </ol>
      </div>
      <div class="col-md-7 col-4 align-self-center">
        <div class="d-flex m-t-10 justify-content-end">
          <div class="d-flex m-r-20 m-l-10 hidden-md-down"></div>
          <div class=""></div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <h3 class="box-title m-b-0">Filter Options</h3>
            <div class="row">
              <div class="form-group col-sm-12 col-md-6">
                Profile
                <select class="form-control form-control-sm" name="cProfile">
                  <xsl:for-each select="Filter[@Description = 'PROFILE']">
                    <option value="{@Value}">
                      <xsl:if test="@Selected='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:value-of select="@Text"/>
                    </option>
                  </xsl:for-each>
                </select>
              </div>

              <div class="form-group col-sm-12 col-md-6">
                Profile Limits
                <select class="form-control form-control-sm" name="cProfileLimits">
                  <xsl:for-each select="Filter[@Description = 'PROFILELIMITS']">
                    <option value="{@Value}">
                      <xsl:if test="@Selected='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:value-of select="@Text"/>
                    </option>
                  </xsl:for-each>
                </select>
              </div>

              <div class="form-group col-sm-12 col-md-6">
                Player Rate
                <select class="form-control form-control-sm" name="cPlayerRate">
                  <xsl:for-each select="Filter[@Description = 'PLAYERRATE']">
                    <option value="{@Value}">
                      <xsl:if test="@Selected='1'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
                      <xsl:value-of select="@Text"/>
                    </option>
                  </xsl:for-each>
                </select>
              </div>

              <div class="form-group col-sm-12 col-md-6">
                Player
                <input maxlength="10" type="text" class="form-control form-control-sm" name="txtPlayer" id="txtPlayer" value="{@Player}"/>
              </div>

              <div class="form-group col-sm-12 col-md-1 offset-md-5">
                <input type="button" value="Submit" class="btn btn-success" onclick="document.forms[0].action = 'PlayerMessage.aspx';document.forms[0].submit();"/>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <br/>

    <input type="hidden" name="HDPlayers" id="HDPlayers"/>

    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <div class="row">
              <div id="Holder" style="width:100%;height:350px;overflow:auto;">
                <div class="table-responsive">
                  <table class="table color-table success-table table-bordered table-striped table-sm">
                    <thead>
                      <tr class="GameHeader">
                        <th>Player</th>
                        <th>Profile</th>
                        <th>Profile Limits</th>
                      </tr>
                    </thead>
                    <tbody>
                      <xsl:for-each select="detail">
                        <tr>
                          <td>
                            <input type="checkbox" id="chk_{@IdPlayer}" name="chk_{@IdPlayer}" value="{@IdPlayer}" checked="checked"/>
                            <xsl:value-of select="@Player"/>
                          </td>
                          <td><xsl:value-of select="@Profile"/></td>
                          <td><xsl:value-of select="@PlayerProfileLimits"/></td>
                        </tr>
                      </xsl:for-each>
                    </tbody>
                  </table>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <div class="row">
      <div class="col-lg-12">
        <div class="card">
          <div class="card-body">
            <h3 class="box-title m-b-0">Player Message</h3>

            <table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
              <tr>
                <td width="60%">Message</td>
                <td style="border:solid 1px #000;">
                  Type:
                  <label style="margin-left:8px; margin-right:12px;">
                    <input type="radio" name="MsgType" value="Normal" checked="checked"/> Normal
                  </label>
                  <label>
                    <input type="radio" name="MsgType" value="Permanent"/> Permanent
                  </label>
                </td>
              </tr>
              <tr>
                <td>
                  <textarea name="txtMsg" cols="50" rows="7" id="txtMsg"></textarea>
                </td>
                <td valign="top" style="border:solid 1px #000;">
                  <table cellspacing="0" cellpadding="0" border="0" width="100%">
                    <tr>
                      <td align="left">
                        <label for="ch_Expiration">
                          <input type="checkbox" id="ch_Expiration" name="ch_Expiration"/> Expiration Date
                        </label>
                      </td>
                      <td align="right">
                        <input style="width:100px" type="text" class="form-control form-control-sm datepicker" name="Date1" value="" id="Date1"/>
                      </td>
                    </tr>
                    <tr>
                      <td align="left">
                        <label for="ch_DisplayCounter">
                          <input type="checkbox" id="ch_DisplayCounter" name="ch_DisplayCounter"/> Display Counter
                        </label>
                      </td>
                      <td align="right">
                        <input style="width:120px" type="text" class="form-control form-control-sm" maxlength="4" name="txtCounter" id="txtCounter"/>
                      </td>
                    </tr>
                    <tr>
                      <td colspan="2" align="left">
                        <label for="ch_DisableMsg">
                          <input type="checkbox" id="ch_DisableMsg" name="ch_DisableMsg"/> Player can disable message
                        </label>
                      </td>
                    </tr>
                  </table>
                  <br/>
                  <input type="button" class="btn btn-Success" value="Create Message" onclick="CreateMsg();"/>
                </td>
              </tr>
            </table>

          </div>
        </div>
      </div>
    </div>

  </xsl:template>
</xsl:stylesheet>
