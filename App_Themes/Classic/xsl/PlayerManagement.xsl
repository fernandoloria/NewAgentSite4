<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">

        <xsl:variable name="PERMISOEDIT">
            <xsl:call-template name="Permit">
                <xsl:with-param name="Post">11</xsl:with-param>
            </xsl:call-template>
        </xsl:variable>

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
            function post() {
                document.forms[0].submit();
            }

            function GotoMsg() {
                document.forms[0].action = 'PlayerMessage.aspx';
                document.forms[0].submit();
            }

        </SCRIPT>
        <style>
            table {
            table-layout: fixed;
            }
        </style>
        
		<div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Players Management</h3>          
        </div>
    </div>
        <div align="right">
				<xsl:if test="//xml/@AddPlayer = 'True'">
                    <a href="/Report/AddPlayer.aspx" class="btn btn-danger">Add Player</a>
				</xsl:if>
				<xsl:if test="//xml/@AddAgent = 'True'">
					<a href="/Report/AddAgent.aspx" class="btn btn-danger">Add Agent</a>
				</xsl:if>
				<xsl:if test="//xml/@MsgCreate = 'True'">
					<a href="ManagePlayerMessage.aspx" class="btn btn-primary"><i class="fa fa-envelope" aria-hidden="true"></i> New Online Msg</a>
			    </xsl:if>
        </div>
        <xsl:for-each select="agent">
            <div class="row">
                <div class="col-12">
                    <div class="card">
                        <div class="card-body">
                            <h4 class="card-title"></h4>
                            <div class="table-responsive">
                            <TABLE CLASS="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hover-table">
                              <THEAD>
                                <tr class="trAgent">
                                  <th class="hidden-sm-down" colspan="11">
                                    <xsl:value-of select="@Agent" /><xsl:value-of select="//xml/@AddAgent" />
                                  </th>
								                  <th class="hidden-md-up" colspan="5">
                                    <xsl:value-of select="@Agent" />
                                  </th>
                                </tr>
                                
                                    <TR>
                                        <TH>Player / Pass</TH>
                                        <!-- <TH>Password</TH> -->
                                        <TH>Credit Limit</TH>
                                        <TH>Max Wager</TH>
                                        <TH class="hidden-sm-down">Life Time</TH>
                                        <TH class="hidden-sm-down">Enable</TH>
                                        <TH class="hidden-sm-down">Sport</TH>
                                        <TH class="hidden-sm-down">Casino</TH>
                                        <TH class="hidden-sm-down">Horses</TH>
                                        <TH class="hidden-sm-down">Last Wager</TH>
                                        <TH>Edit</TH>
                                        <TH>$PMT</TH>
                                    </TR>
                                </THEAD>
                                <TBODY>
                                <xsl:for-each select="player">
                                    <TR>
                                        <TD>
                                            <A HREF="#" onclick="window.open('../popup/PlayerStats.aspx?Player={@IdPlayer}',null,'scrollbars=yes,directories=no,height=400,width=700,menubar=no,left=50,top=80')">
                                                <xsl:value-of disable-output-escaping="yes" select="@Player" />
                                            </A> - <xsl:value-of disable-output-escaping="yes" select="@Password" />
                                        </TD>
                                        <!-- <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="@Password" />
                                        </TD>-->
                                        <TD>
                                            <xsl:value-of select="@Symbol" />
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@CreditLimit,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of select="@Symbol" />
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@MaxWager,'###,##0')" />
                                        </TD>
                                        <TD class="hidden-sm-down">
                                            <xsl:value-of select="@Symbol" />
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@MinWager,'###,##0')" />
                                        </TD>
                                        <TD class="hidden-sm-down">
                                            <xsl:if test="@Enabled = 'True'">
                                                Yes
                                            </xsl:if>
                                            <xsl:if test="@Enabled = 'False'">
                                                <span class="neg">No</span>
                                            </xsl:if>
                                        </TD>
                                        <TD class="hidden-sm-down">
                                            <xsl:if test="@EnableSport = 'True'">
                                                Yes
                                            </xsl:if>
                                            <xsl:if test="@EnableSport = 'False'">
                                                <span class="neg">No</span>
                                            </xsl:if>
                                        </TD>
                                        <TD class="hidden-sm-down">
                                            <xsl:if test="@EnableCasino = 'True'">
                                                Yes
                                            </xsl:if>
                                            <xsl:if test="@EnableCasino = 'False'">
                                                <span class="neg">No</span>
                                            </xsl:if>
                                        </TD>
                                        <TD class="hidden-sm-down">
                                            <xsl:if test="@EnableHorses = 'True'">
                                                Yes
                                            </xsl:if>
                                            <xsl:if test="@EnableHorses = 'False'">
                                                <span class="neg">No</span>
                                            </xsl:if>
                                        </TD>
                                        <TD class="hidden-sm-down">
                                            <xsl:value-of disable-output-escaping="yes" select="@LastWager" />
                                        </TD>
                                        <TD>
                                            <xsl:if test="$PERMISOEDIT = 'Yes'">
                                                <A HREF="PlayerEditEnhanced.aspx?player={@IdPlayer}">
                                                    <button type="button" class="btn btn-warning btn-sm"><i 
class="fa fa-pencil-square" 
aria-hidden="true"></i></button>
                                                </A>
                                            </xsl:if>
                                            </TD>
                                            <TD>
                                            <xsl:if test="//xml/@PaymentRight = 'True'">
                                                <a href="PlayerPayment.aspx?player={@IdPlayer}">
                                                    <button type="button" class="btn btn-success btn-sm"><i class="fa fa-usd" aria-hidden="true"></i></button>
                                                </a>
                                            </xsl:if>
                                        </TD>
                                    </TR>
                                    <!-- <TR>
                                        <TD>

                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="@OnlinePassword" />
                                        </TD>
                                        <TD>

                                        </TD>
                                        <TD>
                                            <xsl:value-of select="@Symbol" />
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@OnlineMaxWager,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of select="@Symbol" />
                                            <xsl:value-of disable-output-escaping="yes" select="format-number(@OnlineMinWager,'###,##0')" />
                                        </TD>
                                        <TD>
                                            <xsl:if test="@EnableOnline = 'True'">
                                                Yes
                                            </xsl:if>
                                            <xsl:if test="@EnableOnline = 'False'">
                                                No
                                            </xsl:if>
                                        </TD>
                                        <TD>

                                        </TD>
                                        <TD>

                                        </TD>
                                        <TD>
                                            
                                        </TD>
                                    </TR> -->

                                </xsl:for-each>
                                </TBODY>
                            </TABLE>
                            </div>
                            <p>
                                <xsl:if test="count(//player)=0">
                                    No Players
                                </xsl:if>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </xsl:for-each>
    </xsl:template>
    <xsl:template name="Permit">
        <xsl:param name="Post" />
        <xsl:for-each select="//*[position() = $Post]">
            <xsl:if test="@Allow = 'True'">Yes</xsl:if>
            <xsl:if test="@Allow = 'False'">No</xsl:if>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
