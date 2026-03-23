<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">
    <SCRIPT LANGUAGE="JavaScript" SRC="../App_Themes/Classic/CalendarPopup.js"></SCRIPT>
    <SCRIPT LANGUAGE="JavaScript">
      var cal = new CalendarPopup();
      function post() {
      document.forms[0].action = 'EventSchedule.aspx';
      document.forms[0].submit();
      }
    </SCRIPT>

    <INPUT type="hidden" name="OriGame" id="OriGame" value="{@IdGame}_{@Sport}" />

    <center>
      <div style="width:100%">
        <h1>Events</h1>
      </div>
      
      
      <table CELLSPACING="0" CELLPADDING="0" BORDER="0" style="border:solid #000000 1px;" width="100%">
        <tr>
          <td colspan="3" align="right">
            <xsl:if test="count(GameDetail) > 0 or count(GameTNT) > 0">
              <input type="SUBMIT" class="btn btn-primary"  value="Save" />
            </xsl:if>
            <input type="SUBMIT" class="btn btn-primary"  value="Refresh" />
            <input type="button" value="Close" data-bs-dismiss="modal"/>
          </td>
        </tr>
        <tr class="TrAction">
          <td class="ChangeLine">
            <input type="radio" name="ActionR" value="Change" onclick="BlockDiv('Change');">
              <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
              Change Line
            </input>
          </td>
          <td class="ActionLine">
            ACTION:
            <input type="radio" name="ActionR" value="Action" onclick="BlockDiv('Action');">Default</input>
            <input type="radio" name="ActionR" value="Master" onclick="BlockDiv('Master');">Master</input>
            <input type="radio" name="ActionR" value="Sum" onclick="BlockDiv('Sum');">Sum</input>
          </td>
          <td align="center">
            TYPE:
            <input type="radio" name="TypeM" value="Risk" onclick="BlockMoney('Risk');">
              <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
              Risk
            </input>
            <input type="radio" name="TypeM" value="Win" onclick="BlockMoney('Win');">Win</input>
          </td>
        </tr>
      </table>
      <input type="hidden" name="TabChanged" id="TabChanged" value="" />

      <xsl:for-each select="GameDetail">
        <xsl:if test="@IdSport = 'NFL' or @IdSport = 'CFB' or @IdSport = 'NBA' or @IdSport = 'CBB'">
          <table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
                <xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <tr class="TRTitle">
              <td colspan="9" align="Left">
                <xsl:value-of select="@EventDescription"/>
              </td>
            </tr>
            <tr class="TRTitle">
              <td style="width:7%;border-bottom:solid 1px #000;">D/T</td>
              <td style="width:4%;border-bottom:solid 1px #000;">#</td>
              <td style="width:15%;border-bottom:solid 1px #000;">Team Name</td>
              <td style="width:13%;border-bottom:solid 1px #000;">
                Spread
              </td>
              <td style="width:13%;border-bottom:solid 1px #000;">
                Odds
              </td>
              <td style="width:13%;border-bottom:solid 1px #000;">
                Total
              </td>
              <td style="width:13%;border-bottom:solid 1px #000;">
                Odds
              </td>
              <td style="width:13%;border-bottom:solid 1px #000;">
                $-Line
              </td>
              <td style="width:7%;border-bottom:solid 1px #000;">
                Hidden
              </td>
            </tr>
            <tr>
              <td>
                <xsl:value-of select="@GameDateTime"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorNumber"/>
                <br />
                <xsl:value-of select="@HomeNumber"/>
              </td>
              <td style="border-right:solid 1px #000;">
                <xsl:value-of select="@VisitorTeam"/>
                <br />
                <xsl:value-of select="@HomeTeam"/>
              </td>
              <xsl:if test="@HideGame = 'False'">
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpread"/>
                          <xsl:if test="@AgVisitorSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vsp_{@IdGame}_3_{@IdSport}" name="txt_vsp_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_3', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpread"/>
                          <xsl:if test="@AgHomeSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hsp_{@IdGame}_3_{@IdSport}" name="txt_hsp_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_3', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off" />
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpreadOdds"/>
                          <xsl:if test="@AgVisitorSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vso_{@IdGame}_4_{@IdSport}" name="txt_vso_{@IdGame}_4_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_4', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off" />
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpreadOdds"/>
                          <xsl:if test="@AgHomeSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hso_{@IdGame}_4_{@IdSport}" name="txt_hso_{@IdGame}_4_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_4', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off" />
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@TotalOver"/>
                          <xsl:if test="@AgTotalOver != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalOver"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tov_{@IdGame}_7_{@IdSport}" name="txt_tov_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_7', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@TotalUnder"/>
                          <xsl:if test="@AgTotalUnder != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalUnder"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tun_{@IdGame}_7_{@IdSport}" name="txt_tun_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_7', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@OverOdds"/>
                          <xsl:if test="@AgOverOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgOverOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_ood_{@IdGame}_8_{@IdSport}" name="txt_ood_{@IdGame}_8_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_8', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@UnderOdds"/>
                          <xsl:if test="@AgUnderOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgUnderOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_uod_{@IdGame}_8_{@IdSport}" name="txt_uod_{@IdGame}_8_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_8', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideMoneyLine = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorOdds"/>
                          <xsl:if test="@AgVisitorOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vod_{@IdGame}_11_{@IdSport}" name="txt_vod_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_11', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeOdds"/>
                          <xsl:if test="@AgHomeOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hod_{@IdGame}_11_{@IdSport}" name="txt_hod_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_11', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="@HideGame = 'True'">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </xsl:if>
              <td style="border-left:solid 1px #000;">
                <table cellspacing="0" cellpadding="0" border="0">
                  <tr>
                    <td align="right">
                      Game
                      <INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
                        <xsl:if test="@HideGame = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      Spread
                      <INPUT id="chk_HideSpread_{@IdGame}" type="checkbox" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}" onclick="ChangeHD('chk_HideSpread_' + {@IdGame});">
                        <xsl:if test="@HideSpread = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      Total
                      <INPUT id="chk_HideTotal_{@IdGame}" type="checkbox" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}" onclick="ChangeHD('chk_HideTotal_' + {@IdGame});">
                        <xsl:if test="@HideTotal = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      $-Line
                      <INPUT id="chk_HideMoneyLine_{@IdGame}" type="checkbox" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}" onclick="ChangeHD('chk_HideMoneyLine_' + {@IdGame});">
                        <xsl:if test="@HideMoneyLine = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr class="FollowLine">
              <td colspan="2" style="border-top:solid 1px #000;">
                <xsl:if test="@OffBoard = 'True'">
                  Off The Board
                </xsl:if>
                <xsl:if test="@OffBoard = 'False'">
                  Open Game
                </xsl:if>
              </td>
              <td colspan="6" style="padding-left:20px;text-align:left;border-top:solid 1px #000;">
                Follow Line
                <INPUT id="chk_Follow_{@IdGame}" type="checkbox" name="chk_Follow_{@IdGame}" value="{@Follow}" onclick="ChangeHD('chk_Follow_' + {@IdGame});">
                  <xsl:if test="@Follow = 'True'">
                    <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                  </xsl:if>
                </INPUT>
              </td>
              <td align="right" style="border-top:solid 1px #000;">
                <INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetEventLine({@IdGame} + '_' + '{@IdSport}')" />
              </td>
            </tr>
          </table>
          <br />
        </xsl:if>

        <xsl:if test="@IdSport = 'MU' or @IdSport = 'SOC'">
          <table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
                <xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <tr class="TRTitle">
              <td colspan="9" align="Left">
                <xsl:value-of select="@EventDescription"/>
              </td>
            </tr>
            <tr class="TRTitle">
              <td style="width:7%;border-bottom:solid 1px #000;">D/T</td>
              <td style="width:4%;border-bottom:solid 1px #000;">#</td>
              <td style="width:15%;border-bottom:solid 1px #000;">Team Name</td>
              <td style="width:13%;border-bottom:solid 1px #000;">$-Ln</td>
              <td style="width:13%;border-bottom:solid 1px #000;">Total</td>
              <td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
              <xsl:if test="@IdSport = 'MU'">
                <td style="border-bottom:solid 1px #000;">Spread</td>
              </xsl:if>
              <xsl:if test="@IdSport = 'SOC'">
                <td style="border-bottom:solid 1px #000;">Goals</td>
              </xsl:if>
              <td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
              <td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
            </tr>

            <tr>

              <td>
                <xsl:value-of select="@GameDateTime"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorNumber"/>
                <br />
                <xsl:value-of select="@HomeNumber"/>
                <xsl:if test="@IdSport = 'SOC'">
                  <br />
                  <xsl:value-of select="(@HomeNumber + 1)"/>
                </xsl:if>
              </td>
              <td>
                <xsl:value-of select="@VisitorTeam"/>
                <br />
                <xsl:value-of select="@HomeTeam"/>
                <xsl:if test="@IdSport = 'SOC'">
                  <br />
                  DRAW
                </xsl:if>
              </td>
              <xsl:if test="@HideGame = 'False'">
                <td>
                  <xsl:if test="@HideMoneyLine = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorOdds"/>
                          <xsl:if test="@AgVisitorOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vod_{@IdGame}_3_{@IdSport}" name="txt_vod_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_3', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeOdds"/>
                          <xsl:if test="@AgHomeOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hod_{@IdGame}_3_{@IdSport}" name="txt_hod_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_3', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <xsl:if test="@IdSport = 'SOC'">
                        <tr>
                          <td>
                            <xsl:value-of select="@VisitorSpecialOdds"/>
                            <xsl:if test="@AgVisitorSpecialOdds != ''">
                              [<font class="AgScheduleColor">
                                <xsl:value-of select="@AgVisitorSpecialOdds"/>
                              </font>]
                            </xsl:if>
                          </td>
                          <td>
                            <div class="Action">
                              <div class="Risk">
                                <xsl:if test="detail[@Description='Action']/@VisitorSpecialRisk != ''">
                                  <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_2')">
                                    <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpecialCount"/>
                                  </a>
                                </xsl:if>
                              </div>
                              <div class="Win">
                                <xsl:if test="detail[@Description='Action']/@VisitorSpecialWin != ''">
                                  <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_2')">
                                    <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpecialCount"/>
                                  </a>
                                </xsl:if>
                              </div>
                            </div>
                            <div class="Master">
                              <div class="Risk">
                                <xsl:if test="detail[@Description='Master']/@VisitorSpecialRisk != ''">
                                  <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_1')">
                                    <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpecialCount"/>
                                  </a>
                                </xsl:if>
                              </div>
                              <div class="Win">
                                <xsl:if test="detail[@Description='Master']/@VisitorSpecialWin != ''">
                                  <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_1')">
                                    <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpecialCount"/>
                                  </a>
                                </xsl:if>
                              </div>
                            </div>
                            <div class="Sum">
                              <div class="Risk">
                                <xsl:if test="detail[@Description='Sum']/@VisitorSpecialRisk != ''">
                                  <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_0')">
                                    <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpecialCount"/>
                                  </a>
                                </xsl:if>
                              </div>
                              <div class="Win">
                                <xsl:if test="detail[@Description='Sum']/@VisitorSpecialWin != ''">
                                  <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_0')">
                                    <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpecialCount"/>
                                  </a>
                                </xsl:if>
                              </div>
                            </div>
                            <div class="Change">
                              <input TYPE="text" class="form-control form-control-sm" id="txt_vss_{@IdGame}_3_{@IdSport}" name="txt_vss_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vss_' + {@IdGame}  + '_3', '{@VisitorSpecialOdds}', '{@AgVisitorSpecialOdds}', 'Odds')" autocomplete="off"/>
                            </div>
                          </td>
                        </tr>
                      </xsl:if>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@TotalOver"/>
                          <xsl:if test="@AgTotalOver != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalOver"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tov_{@IdGame}_5_{@IdSport}" name="txt_tov_{@IdGame}_5_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_5', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@TotalUnder"/>
                          <xsl:if test="@AgTotalUnder != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalUnder"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tun_{@IdGame}_5_{@IdSport}" name="txt_tun_{@IdGame}_5_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_5', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@OverOdds"/>
                          <xsl:if test="@AgOverOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgOverOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_ood_{@IdGame}_7_{@IdSport}" name="txt_ood_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_7', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@UnderOdds"/>
                          <xsl:if test="@AgUnderOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgUnderOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_uod_{@IdGame}_7_{@IdSport}" name="txt_uod_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_7', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpread"/>
                          <xsl:if test="@AgVisitorSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vsp_{@IdGame}_10_{@IdSport}" name="txt_vsp_{@IdGame}_10_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_10', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpread"/>
                          <xsl:if test="@AgHomeSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hsp_{@IdGame}_10_{@IdSport}" name="txt_hsp_{@IdGame}_10_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_10', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpreadOdds"/>
                          <xsl:if test="@AgVisitorSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_vso_{@IdGame}_11_{@IdSport}" name="txt_vso_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_11', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpreadOdds"/>
                          <xsl:if test="@AgHomeSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_hso_{@IdGame}_11_{@IdSport}" name="txt_hso_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_11', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="@HideGame = 'True'">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </xsl:if>
              <td>
                <table cellspacing="0" cellpadding="0" border="0">
                  <tr>
                    <td align="right">
                      Game
                      <INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
                        <xsl:if test="@HideGame = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      <xsl:if test="@IdSport = 'MU'">
                        Spread
                      </xsl:if>
                      <xsl:if test="@IdSport = 'SOC'">
                        Goal
                      </xsl:if>
                      <INPUT id="chk_HideSpread_{@IdGame}" type="checkbox" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}" onclick="ChangeHD('chk_HideSpread_' + {@IdGame});">
                        <xsl:if test="@HideSpread = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      Total
                      <INPUT id="chk_HideTotal_{@IdGame}" type="checkbox" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}" onclick="ChangeHD('chk_HideTotal_' + {@IdGame});">
                        <xsl:if test="@HideTotal = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      $-Line
                      <INPUT id="chk_HideMoneyLine_{@IdGame}" type="checkbox" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}" onclick="ChangeHD('chk_HideMoneyLine_' + {@IdGame});">
                        <xsl:if test="@HideMoneyLine = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr class="FollowLine">
              <td colspan="2" style="border-top:solid 1px #000;">
                <xsl:if test="@OffBoard = 'True'">
                  Off The Board
                </xsl:if>
                <xsl:if test="@OffBoard = 'False'">
                  Open Game
                </xsl:if>
              </td>
              <td colspan="6" style="padding-left:20px;text-align:left;border-top:solid 1px #000;">
                Follow Line
                <INPUT id="chk_Follow_{@IdGame}" type="checkbox" name="chk_Follow_{@IdGame}" value="{@Follow}" onclick="ChangeHD('chk_Follow_' + {@IdGame});">
                  <xsl:if test="@Follow = 'True'">
                    <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                  </xsl:if>
                </INPUT>
              </td>
              <td align="right" style="border-top:solid 1px #000;">
                <INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetEventLine({@IdGame} + '_' + '{@IdSport}')" />
              </td>
            </tr>
          </table>
          <br />
        </xsl:if>

        <xsl:if test="@IdSport = 'MLB'">
          <table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
                <xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <tr class="TRTitle">
              <td colspan="9" align="Left">
                <xsl:value-of select="@EventDescription"/>
              </td>
            </tr>
            <tr class="TRTitle">
              <td style="width:7%;border-bottom:solid 1px #000;">D/T</td>
              <td style="width:4%;border-bottom:solid 1px #000;">#</td>
              <td style="width:15%;border-bottom:solid 1px #000;">Team Name</td>
              <td style="width:13%;border-bottom:solid 1px #000;">$-Ln</td>
              <td style="width:13%;border-bottom:solid 1px #000;">Total</td>
              <td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
              <td style="width:13%;border-bottom:solid 1px #000;">R-L</td>
              <td style="width:13%;border-bottom:solid 1px #000;">Odds</td>
              <td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
            </tr>

            <tr>

              <td>
                <xsl:value-of select="@GameDateTime"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorNumber"/>
                <br />
                <xsl:value-of select="@HomeNumber"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorTeam"/>
                <br />
                <xsl:value-of select="@HomeTeam"/>
              </td>
              <xsl:if test="@HideGame = 'False'">
                <td>
                  <xsl:if test="@HideMoneyLine = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorOdds"/>
                          <xsl:if test="@AgVisitorOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vod_{@IdGame}_4_{@IdSport}" name="txt_vod_{@IdGame}_4_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_4', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeOdds"/>
                          <xsl:if test="@AgHomeOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hod_{@IdGame}_4_{@IdSport}" name="txt_hod_{@IdGame}_4_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_4', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@TotalOver"/>
                          <xsl:if test="@AgTotalOver != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalOver"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tov_{@IdGame}_7_{@IdSport}" name="txt_tov_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_7', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@TotalUnder"/>
                          <xsl:if test="@AgTotalUnder != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalUnder"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tun_{@IdGame}_7_{@IdSport}" name="txt_tun_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_7', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@OverOdds"/>
                          <xsl:if test="@AgOverOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgOverOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_ood_{@IdGame}_8_{@IdSport}" name="txt_ood_{@IdGame}_8_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_8', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@UnderOdds"/>
                          <xsl:if test="@AgUnderOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgUnderOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_uod_{@IdGame}_8_{@IdSport}" name="txt_uod_{@IdGame}_8_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_8', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpread"/>
                          <xsl:if test="@AgVisitorSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vsp_{@IdGame}_11_{@IdSport}" name="txt_vsp_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_11', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpread"/>
                          <xsl:if test="@AgHomeSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hsp_{@IdGame}_11_{@IdSport}" name="txt_hsp_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_11', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpreadOdds"/>
                          <xsl:if test="@AgVisitorSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_vso_{@IdGame}_12_{@IdSport}" name="txt_vso_{@IdGame}_12_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_12', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpreadOdds"/>
                          <xsl:if test="@AgHomeSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_hso_{@IdGame}_12_{@IdSport}" name="txt_hso_{@IdGame}_12_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_12', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="@HideGame = 'True'">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </xsl:if>
              <td>
                <table cellspacing="0" cellpadding="0" border="0">
                  <tr>
                    <td align="right">
                      Game
                      <INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
                        <xsl:if test="@HideGame = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      R-L
                      <INPUT id="chk_HideSpread_{@IdGame}" type="checkbox" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}" onclick="ChangeHD('chk_HideSpread_' + {@IdGame});">
                        <xsl:if test="@HideSpread = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      Total
                      <INPUT id="chk_HideTotal_{@IdGame}" type="checkbox" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}" onclick="ChangeHD('chk_HideTotal_' + {@IdGame});">
                        <xsl:if test="@HideTotal = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      $-Line
                      <INPUT id="chk_HideMoneyLine_{@IdGame}" type="checkbox" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}" onclick="ChangeHD('chk_HideMoneyLine_' + {@IdGame});">
                        <xsl:if test="@HideMoneyLine = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr class="FollowLine">
              <td colspan="2" style="border-top:solid 1px #000;">
                <xsl:if test="@OffBoard = 'True'">
                  Off The Board
                </xsl:if>
                <xsl:if test="@OffBoard = 'False'">
                  Open Game
                </xsl:if>
              </td>
              <td colspan="6" style="padding-left:20px;text-align:left;border-top:solid 1px #000;">
                Follow Line
                <INPUT id="chk_Follow_{@IdGame}" type="checkbox" name="chk_Follow_{@IdGame}" value="{@Follow}" onclick="ChangeHD('chk_Follow_' + {@IdGame});">
                  <xsl:if test="@Follow = 'True'">
                    <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                  </xsl:if>
                </INPUT>
              </td>
              <td align="right" style="border-top:solid 1px #000;">
                <INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetEventLine({@IdGame} + '_' + '{@IdSport}')" />
              </td>
            </tr>
          </table>
          <br />
        </xsl:if>

        <xsl:if test ="@IdSport = 'NHL'">
          <table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
                <xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <tr class="TRTitle">
              <td colspan="11" align="Left">
                <xsl:value-of select="@EventDescription"/>
              </td>
            </tr>
            <tr class="TRTitle">
              <td style="width:7%;border-bottom:solid 1px #000;">D/T</td>
              <td style="width:4%;border-bottom:solid 1px #000;">#</td>
              <td style="width:12%;border-bottom:solid 1px #000;">Team Name</td>
              <td style="width:10%;border-bottom:solid 1px #000;">$-Line</td>
              <td style="width:10%;border-bottom:solid 1px #000;">Total</td>
              <td style="width:10%;border-bottom:solid 1px #000;">Odds</td>
              <td style="width:10%;border-bottom:solid 1px #000;">C-L</td>
              <td style="width:10%;border-bottom:solid 1px #000;">Odds</td>
              <td style="width:10%;border-bottom:solid 1px #000;">A-L</td>
              <td style="width:10%;border-bottom:solid 1px #000;">Odds</td>
              <td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
            </tr>

            <tr>

              <td>
                <xsl:value-of select="@GameDateTime"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorNumber"/>
                <br />
                <xsl:value-of select="@HomeNumber"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorTeam"/>
                <br />
                <xsl:value-of select="@HomeTeam"/>
              </td>
              <xsl:if test="@HideGame = 'False'">
                <td>
                  <xsl:if test="@HideMoneyLine = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorOdds"/>
                          <xsl:if test="@AgVisitorOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vod_{@IdGame}_3_{@IdSport}" name="txt_vod_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_3', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeOdds"/>
                          <xsl:if test="@AgHomeOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hod_{@IdGame}_3_{@IdSport}" name="txt_hod_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_3', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@TotalOver"/>
                          <xsl:if test="@AgTotalOver != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalOver"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalOverWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V2_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalOverWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalOverCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tov_{@IdGame}_6_{@IdSport}" name="txt_tov_{@IdGame}_6_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tov_' + {@IdGame}  + '_6', '{@TotalOver}', '{@AgTotalOver}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@TotalUnder"/>
                          <xsl:if test="@AgTotalUnder != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgTotalUnder"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@TotalUnderWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H3_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@TotalUnderWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@TotalUnderCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_tun_{@IdGame}_6_{@IdSport}" name="txt_tun_{@IdGame}_6_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_tun_' + {@IdGame}  + '_6', '{@TotalUnder}', '{@AgTotalUnder}', 'Points')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideTotal = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@OverOdds"/>
                          <xsl:if test="@AgOverOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgOverOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_ood_{@IdGame}_7_{@IdSport}" name="txt_ood_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_ood_' + {@IdGame}  + '_7', '{@OverOdds}', '{@AgOverOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@UnderOdds"/>
                          <xsl:if test="@AgUnderOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgUnderOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_uod_{@IdGame}_7_{@IdSport}" name="txt_uod_{@IdGame}_7_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_uod_' + {@IdGame}  + '_7', '{@UnderOdds}', '{@AgUnderOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpecial"/>
                          <xsl:if test="@AgVisitorSpecial!= ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpecial"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vsl_{@IdGame}_10_{@IdSport}" name="txt_vsl_{@IdGame}_10_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsl_' + {@IdGame} + '_10', '{@VisitorSpecial}', '{@AgVisitorSpecial}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpecial"/>
                          <xsl:if test="@AgHomeSpecial != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpecial"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hsl_{@IdGame}_10_{@IdSport}" name="txt_hsl_{@IdGame}_10_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsl_' + {@IdGame}  + '_10', '{@HomeSpecial}', '{@AgHomeSpecial}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpecialOdds"/>
                          <xsl:if test="@AgVisitorSpecialOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpecialOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_vss_{@IdGame}_11_{@IdSport}" name="txt_vss_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vss_' + {@IdGame}  + '_11', '{@VisitorSpecialOdds}', '{@AgVisitorSpecialOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpecialOdds"/>
                          <xsl:if test="@AgHomeSpecialOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpecialOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_hss_{@IdGame}_11_{@IdSport}" name="txt_hss_{@IdGame}_11_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hss_' + {@IdGame}  + '_11', '{@HomeSpecialOdds}', '{@AgHomeSpecialOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpread"/>
                          <xsl:if test="@AgVisitorSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V0_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vsp_{@IdGame}_14_{@IdSport}" name="txt_vsp_{@IdGame}_14_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vsp_' + {@IdGame} + '_14', '{@VisitorSpread}', '{@AgVisitorSpread}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpread"/>
                          <xsl:if test="@AgHomeSpread != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpread"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeSpreadWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H1_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeSpreadWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeSpreadCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hsp_{@IdGame}_14_{@IdSport}" name="txt_hsp_{@IdGame}_14_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hsp_' + {@IdGame}  + '_14', '{@HomeSpread}', '{@AgHomeSpread}', 'Spread')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideSpread = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpreadOdds"/>
                          <xsl:if test="@AgVisitorSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_vso_{@IdGame}_15_{@IdSport}" name="txt_vso_{@IdGame}_15_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vso_' + {@IdGame}  + '_15', '{@VisitorSpreadOdds}', '{@AgVisitorSpreadOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeSpreadOdds"/>
                          <xsl:if test="@AgHomeSpreadOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeSpreadOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <input TYPE="text" class="form-control form-control-sm" id="txt_hso_{@IdGame}_15_{@IdSport}" name="txt_hso_{@IdGame}_15_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hso_' + {@IdGame}  + '_15', '{@HomeSpreadOdds}', '{@AgHomeSpreadOdds}', 'Odds')" autocomplete="off"/>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="@HideGame = 'True'">
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
                <td></td>
              </xsl:if>
              <td>
                <table cellspacing="0" cellpadding="0" border="0">
                  <tr>
                    <td align="right">
                      Game
                      <INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
                        <xsl:if test="@HideGame = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      Spread
                      <INPUT id="chk_HideSpread_{@IdGame}" type="checkbox" name="chk_HideSpread_{@IdGame}" value="{@HideSpread}" onclick="ChangeHD('chk_HideSpread_' + {@IdGame});">
                        <xsl:if test="@HideSpread = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      Total
                      <INPUT id="chk_HideTotal_{@IdGame}" type="checkbox" name="chk_HideTotal_{@IdGame}" value="{@HideTotal}" onclick="ChangeHD('chk_HideTotal_' + {@IdGame});">
                        <xsl:if test="@HideTotal = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                  <tr>
                    <td align="right">
                      $-Line
                      <INPUT id="chk_HideMoneyLine_{@IdGame}" type="checkbox" name="chk_HideMoneyLine_{@IdGame}" value="{@HideMoneyLine}" onclick="ChangeHD('chk_HideMoneyLine_' + {@IdGame});">
                        <xsl:if test="@HideMoneyLine = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr class="FollowLine">
              <td colspan="2" style="border-top:solid 1px #000;">
                <xsl:if test="@OffBoard = 'True'">
                  Off The Board
                </xsl:if>
                <xsl:if test="@OffBoard = 'False'">
                  Open Game
                </xsl:if>
              </td>
              <td colspan="8" style="padding-left:20px;text-align:left;border-top:solid 1px #000;">
                Follow Line
                <INPUT id="chk_Follow_{@IdGame}" type="checkbox" name="chk_Follow_{@IdGame}" value="{@Follow}" onclick="ChangeHD('chk_Follow_' + {@IdGame});">
                  <xsl:if test="@Follow = 'True'">
                    <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                  </xsl:if>
                </INPUT>
              </td>
              <td align="right" style="border-top:solid 1px #000;">
                <INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetEventLine({@IdGame} + '_' + '{@IdSport}')" />
              </td>
            </tr>
          </table>
          <br />
        </xsl:if>

        <xsl:if test="@IdSport = 'PROP'">
          <table cellspacing="1" cellpadding="1" border="0" width="85%" style="border:solid 1px #000;">
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
                <xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <tr class="TRTitle">
              <td colspan="6" align="Left">
                <xsl:value-of select="@EventDescription"/>
              </td>
            </tr>
            <tr class="TRTitle">
              <td style="width:17%;border-bottom:solid 1px #000;">CutOff</td>
              <td style="width:4%;border-bottom:solid 1px #000;">#</td>
              <td style="width:20%;border-bottom:solid 1px #000;">Prop Type</td>
              <td style="width:20%;border-bottom:solid 1px #000;">Description</td>
              <td style="width:20%;border-bottom:solid 1px #000;">Odds</td>
              <td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
            </tr>

            <tr>

              <td>
                <xsl:value-of select="@GameDateTime"/>
              </td>
              <td>
                <xsl:value-of select="@TeamNumber"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorTeam"/>
              </td>
              <td>
                <xsl:value-of select="@HomeTeam"/>
              </td>
              <xsl:if test="@HideGame = 'False'">
                <td>
                  <xsl:if test="@HideGame = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@Odds"/>
                          <xsl:if test="@AgOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_odds_{@IdGame}_4_{@TeamNumber}_{@IdSport}" name="txt_odds_{@IdGame}_4_{@TeamNumber}_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_odds_' + {@IdGame}  + '_4_' + {@TeamNumber}, '{@Odds}', '{@AgOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="@HideGame = 'True'">
                <td></td>
              </xsl:if>
              <td>
                <table cellspacing="0" cellpadding="0" border="0">
                  <tr>
                    <td align="right">
                      Game
                      <INPUT id="chk_HideGame_{@IdGame}_{@TeamNumber}" type="checkbox" name="chk_HideGame_{@IdGame}_{@TeamNumber}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame} + '_' +{@TeamNumber});">
                        <xsl:if test="@HideGame = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr class="FollowLine">
              <td colspan="2" style="border-top:solid 1px #000;">
                <xsl:if test="@OffBoard = 'True'">
                  Off The Board
                </xsl:if>
                <xsl:if test="@OffBoard = 'False'">
                  Open Game
                </xsl:if>
              </td>
              <td colspan="3" style="text-align:left;">
                Follow Line
                <INPUT id="chk_Follow_{@IdGame}_{@TeamNumber}" type="checkbox" name="chk_Follow_{@IdGame}_{@TeamNumber}" value="{@Follow}" onclick="ChangeHD('chk_Follow_' + {@IdGame} + '_' + {@TeamNumber});">
                  <xsl:if test="@Follow = 'True'">
                    <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                  </xsl:if>
                </INPUT>
              </td>
              <td align="right" style="border-top:solid 1px #000;">
                <INPUT id="Reset_{@IdGame}_{@TeamNumber}" type="button" class="btReset" name="Reset_{@IdGame}_{@TeamNumber}" value="Re-Set Line" onclick="ResetEventLine({@IdGame} + '_' + '{@IdSport}' + '_' + {@TeamNumber})" />
              </td>
            </tr>
          </table>
          <br />
        </xsl:if>

        <xsl:if test="@IdSport = 'ESOC'">
          <table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
            <tr>
              <td align="right">
                <SELECT class="form-control form-control-sm"  NAME="cmbLine"  OnChange="post();">
                  <OPTION VALUE="False">
                    <xsl:if test="@AmericanLine='False'">
                      <xsl:attribute name="Selected">Selected</xsl:attribute>
                    </xsl:if>
                    Decimal Line
                  </OPTION>
                  <OPTION VALUE="True">
                    <xsl:if test="@AmericanLine='True'">
                      <xsl:attribute name="Selected">Selected</xsl:attribute>
                    </xsl:if>
                    American Line
                  </OPTION>
                </SELECT>
              </td>
            </tr>
          </table>

          <table cellspacing="1" cellpadding="1" border="0" width="100%" style="border:solid 1px #000;">
            <xsl:attribute name="class">
              <xsl:choose>
                <xsl:when test="count(preceding::GameValues) mod 2 = 0">TrGameScheduleNon</xsl:when>
                <xsl:otherwise>TrGameSchedulePar</xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <tr class="TRTitle">
              <td colspan="7" align="Left">
                <xsl:value-of select="@EventDescription"/>
              </td>
            </tr>
            <tr class="TRTitle">
              <td style="width:17%;border-bottom:solid 1px #000;">D/T</td>
              <td style="width:6%;border-bottom:solid 1px #000;">#</td>
              <td style="width:25%;border-bottom:solid 1px #000;">Teams</td>
              <td style="width:15%;border-bottom:solid 1px #000;">Home</td>
              <td style="width:15%;border-bottom:solid 1px #000;">Draw</td>
              <td style="width:15%;border-bottom:solid 1px #000;">Visitor</td>
              <td style="width:7%;border-bottom:solid 1px #000;">Hidden</td>
            </tr>

            <tr>

              <td>
                <xsl:value-of select="@GameDateTime"/>
              </td>
              <td>
                <xsl:value-of select="@VisitorNumber"/>
              </td>
              <td>
                <xsl:value-of select="@HomeTeam"/>-<xsl:value-of select="@VisitorTeam"/>
              </td>
              <xsl:if test="@HideGame = 'False'">
                <td>
                  <xsl:if test="@HideGame = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td>
                          <xsl:value-of select="@HomeOdds"/>
                          <xsl:if test="@AgHomeOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgHomeOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@HomeRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@HomeWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_H5_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@HomeWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@HomeCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_hod_{@IdGame}_3_{@IdSport}" name="txt_hod_{@IdGame}_3_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_hod_' + {@IdGame}  + '_3', '{@HomeOdds}', '{@AgHomeOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideGame = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorSpecialOdds"/>
                          <xsl:if test="@AgVisitorSpecialOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorSpecialOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpecialRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpecialRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorSpecialWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_D_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorSpecialWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorSpecialCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vss_{@IdGame}_6_{@IdSport}" name="txt_vss_{@IdGame}_6_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vss_' + {@IdGame}  + '_6', '{@VisitorSpecialOdds}', '{@AgVisitorSpecialOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
                <td>
                  <xsl:if test="@HideGame = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@VisitorOdds"/>
                          <xsl:if test="@AgVisitorOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgVisitorOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_vod_{@IdGame}_9_{@IdSport}" name="txt_vod_{@IdGame}_9_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_vod_' + {@IdGame}  + '_9', '{@VisitorOdds}', '{@AgVisitorOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="@HideGame = 'True'">
                <td></td>
                <td></td>
                <td></td>
              </xsl:if>
              <td>
                <table cellspacing="0" cellpadding="0" border="0">
                  <tr>
                    <td align="right">
                      Game
                      <INPUT id="chk_HideGame_{@IdGame}" type="checkbox" name="chk_HideGame_{@IdGame}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame});">
                        <xsl:if test="@HideGame = 'True'">
                          <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                        </xsl:if>
                      </INPUT>
                    </td>
                  </tr>
                </table>
              </td>
            </tr>
            <tr class="FollowLine">
              <td colspan="2" style="border-top:solid 1px #000;">
                <xsl:if test="@OffBoard = 'True'">
                  Off The Board
                </xsl:if>
                <xsl:if test="@OffBoard = 'False'">
                  Open Game
                </xsl:if>
              </td>
              <td colspan="4" style="padding-left:20px;text-align:left;border-top:solid 1px #000;">
                Follow Line
                <INPUT id="chk_Follow_{@IdGame}" type="checkbox" name="chk_Follow_{@IdGame}" value="{@Follow}" onclick="ChangeHD('chk_Follow_' + {@IdGame});">
                  <xsl:if test="@Follow = 'True'">
                    <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                  </xsl:if>
                </INPUT>
              </td>
              <td align="right" style="border-top:solid 1px #000;">
                <INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetEventLine({@IdGame} + '_' + '{@IdSport}')" />
              </td>
            </tr>
          </table>
          <br />
        </xsl:if>
      </xsl:for-each>

      <xsl:for-each select="GameTNT">
        <table cellspacing="1" cellpadding="1" border="0" width="90%" style="border:solid 1px #000;">
          <tr class="TrGameScheduleNon">
            <td colspan="7" align="Left">
              <xsl:value-of select="GameDetail//@EventDescription"/>
            </td>
          </tr>
          <tr class="TrGameScheduleNon">
            <td style="width:17%;border-bottom:solid 1px #000;">CutOff</td>
            <td style="width:6%;border-bottom:solid 1px #000;">#</td>
            <td style="width:25%;border-bottom:solid 1px #000;">Description</td>
            <td style="width:20%;border-bottom:solid 1px #000;">Odds</td>
            <td style="width:25%;border-bottom:solid 1px #000;">Last Update</td>
            <td style="width:7%;border-bottom:solid 1px #000;">Hiden</td>
            <td style="width:7%;border-bottom:solid 1px #000;">FL</td>
          </tr>
          <tr class="GameHeader">
            <td>
              <xsl:value-of select ="@CutOfTime"/>
            </td>
            <td></td>
            <td>
              <xsl:value-of select ="@Description"/>
            </td>
            <td></td>
            <td></td>
            <td>
              <INPUT id="chk_HideGame_{@IdGame}_{@IdSport}" type="checkbox" name="chk_HideGame_{@IdGame}_{@IdSport}" value="{@HideGame}" onclick="ChangeHD('chk_HideGame_' + {@IdGame}+ '_' +'{@IdSport}');">
                <xsl:if test="@HideGame = 'True'">
                  <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                </xsl:if>
              </INPUT>
            </td>
            <td>
              <INPUT id="chk_Follow_{@IdGame}_{@IdSport}" type="checkbox" name="chk_Follow_{@IdGame}_{@IdSport}" value="{@Follow}" onclick="ChangeHD('chk_Follow_' + {@IdGame}+ '_' +'{@IdSport}');">
                <xsl:if test="@Follow = 'True'">
                  <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                </xsl:if>
              </INPUT>
            </td>
          </tr>
          <xsl:for-each select="GameDetail">
            <tr class="TrGameSchedulePar">
              <td></td>
              <td>
                <xsl:value-of select="@TeamNumber"/>
              </td>
              <td>
                <xsl:value-of select="@HomeTeam"/>
              </td>
              <xsl:if test="@HideGame = 'False'">
                <td>
                  <xsl:if test="@HideGame = 'False'">
                    <table cellspacing="0" cellpadding="0" border="0" style="table-layout:fixed;">
                      <tr>
                        <td style="width:70%;">
                          <xsl:value-of select="@Odds"/>
                          <xsl:if test="@AgOdds != ''">
                            [<font class="AgScheduleColor">
                              <xsl:value-of select="@AgOdds"/>
                            </font>]
                          </xsl:if>
                        </td>
                        <td>
                          <div class="Action">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Action']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Action']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_2')">
                                  <xsl:value-of select="format-number(detail[@Description='Action']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Action']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Master">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Master']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Master']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_1')">
                                  <xsl:value-of select="format-number(detail[@Description='Master']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Master']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Sum">
                            <div class="Risk">
                              <xsl:if test="detail[@Description='Sum']/@VisitorRisk != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorRisk,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                            <div class="Win">
                              <xsl:if test="detail[@Description='Sum']/@VisitorWin != ''">
                                <a href="#" onclick="GetGameActionDetail({@IdGame} + '_V4_0')">
                                  <xsl:value-of select="format-number(detail[@Description='Sum']/@VisitorWin,'###,##0')"/> - <xsl:value-of select="detail[@Description='Sum']/@VisitorCount"/>
                                </a>
                              </xsl:if>
                            </div>
                          </div>
                          <div class="Change">
                            <input TYPE="text" class="form-control form-control-sm" id="txt_odds_{@IdGame}_3_{@TeamNumber}_{@IdSport}" name="txt_odds_{@IdGame}_3_{@TeamNumber}_{@IdSport}" value="" class="InputTxt" onkeyup="ShowCode(event,'txt_odds_' + {@IdGame}  + '_3_' + {@TeamNumber}, '{@Odds}', '{@AgOdds}', 'Odds')" autocomplete="off"/>
                          </div>
                        </td>
                      </tr>
                    </table>
                  </xsl:if>
                </td>
              </xsl:if>
              <xsl:if test="@HideGame = 'True'">
                <td></td>
              </xsl:if>
              <td>
                <xsl:value-of select="@GameDateTime"/>
              </td>
              <td></td>
              <td></td>
            </tr>
          </xsl:for-each>
          <tr class="FollowLine">
            <td colspan="4" style="border-top:solid 1px #000;">
              <xsl:if test="@OffBoard = 'True'">
                Off The Board
              </xsl:if>
              <xsl:if test="@OffBoard = 'False'">
                Open Game
              </xsl:if>
            </td>
            <td colspan="3" align="right" style="border-top:solid 1px #000;">
              <INPUT id="Reset_{@IdGame}" type="button" class="btReset" name="Reset_{@IdGame}" value="Re-Set Line" onclick="ResetEventLine({@IdGame} + '_' + '{@IdSport}')" />
            </td>
          </tr>
        </table>
        <br />
      </xsl:for-each>

      <table cellspacing="0" cellpadding="0" border="0">
        <tr>
          <td>
            <xsl:if test="count(GameDetail) > 0 or count(GameTNT) > 0">
              <input type="SUBMIT" class="btn btn-primary"  value="Save" />
            </xsl:if>
          </td>
          <td>
            <input type="button" value="Close" data-bs-dismiss="modal"/>
          </td>
        </tr>
      </table>

    </center>
  </xsl:template>


</xsl:stylesheet>
