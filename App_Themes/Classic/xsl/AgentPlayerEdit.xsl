<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">

    <xsl:variable name="PERMISOLIMITSCREINC">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">1</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOLIMITSCREDEC">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">2</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOLIMITSWAGLINC">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">3</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOLIMITSWAGLDEC">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">4</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOLIMITSWAGOINC">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">5</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOLIMITSWAGODEC">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">6</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOACCESS">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">7</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOPLAYER">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">8</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOCHANGETEMP">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">9</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOLIMITS">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">10</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="PERMISOEDIT">
      <xsl:call-template name="Permit">
        <xsl:with-param name="Post">11</xsl:with-param>
      </xsl:call-template>
    </xsl:variable>

    <CENTER>

      <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="100%" >
        <TR CLASS="GameHeader">
          <TD colspan="2"  align="center">
            Player: <xsl:value-of disable-output-escaping="yes" select="@Player"/> Editing
          </TD>
        </TR>
        <TR CLASS="GameHeader">
          <TD width="50%" align="center">
            <font size="2">
              <strong>ACCESS</strong>
            </font>
          </TD>
          <TD width="50%" align="center">
            <font size="2">
              <strong>LIMITS</strong>
            </font>
          </TD>
        </TR>
        <TR CLASS="TrGameOdd">
          <TD width="50%" valign="middle" align="center">
            <xsl:if test="$PERMISOPLAYER = 'Yes'">
              <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="90%" >
                <TR>
                  <TD>Name</TD>
                  <TD>
                    <INPUT id="txtName" type="text" name="txtName" maxlength="20" value="{@Name}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="htxtName" ID="htxtName" VALUE="{@Name}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Middle Name</TD>
                  <TD>
                    <INPUT id="txtLastName" type="text" name="txtLastName" maxlength="20" value="{@LastName}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="htxtLastName" ID="htxtLastName" VALUE="{@LastName}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Last Name</TD>
                  <TD>
                    <INPUT id="txtLastName2" type="text" name="txtLastName2" maxlength="20" value="{@LastName2}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="htxtLastName2" ID="htxtLastName2" VALUE="{@LastName2}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Password</TD>
                  <TD>
                    <INPUT id="txtPass" type="text" name="txtPass" maxlength="20" value="{@Password}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="htxtPass" ID="htxtPass" VALUE="{@Password}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Online Password</TD>
                  <TD>
                    <INPUT id="txtPassOnline" type="text" name="txtPassOnline" maxlength="20" value="{@OnlinePassword}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="htxtPassOnline" ID="htxtPassOnline" VALUE="{@OnlinePassword}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Phone Number</TD>
                  <TD>
                    <INPUT id="txtPhoneNumber" type="text" name="txtPhoneNumber" maxlength="15" value="{@Phone}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="htxtPhoneNumber" ID="htxtPhoneNumber" VALUE="{@Phone}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Email Address</TD>
                  <TD>
                    <INPUT id="txtEmail" type="text" name="txtEmail" maxlength="50" value="{@Email}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="htxtEmail" ID="htxtEmail" VALUE="{@Email}" />
                  </TD>
                </TR>
              </TABLE>
            </xsl:if>
          </TD>
          <TD valign="middle" align="center">
            <xsl:if test="$PERMISOCHANGETEMP = 'Yes'">
              <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="90%" >
                <TR>
                  <TD>Temp Credit</TD>
                  <TD>
                    <INPUT id="txtTempCredit" type="text" name="txtTempCredit" value="{format-number(@TempCredit,//xml/@MoneyFormat)}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hTempCredit" ID="hTempCredit" VALUE="{@TempCredit}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Temp Credit Expire</TD>
                  <TD>
                    <INPUT id="txtTempCreditExp" TITLE="The Format is mm/dd/yyyy ej: 7/15/2002 for July 15 2002" type="text" name="txtTempCreditExp" value="{@TempCreditExpire}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hTempCreditExp" ID="hTempCreditExp" VALUE="{@TempCreditExpire}" />
                  </TD>
                </TR>
              </TABLE>
            </xsl:if>
            <hr />
            <xsl:if test="$PERMISOPLAYER = 'Yes'">
              <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="90%" >
                <TR>
                  <TD>Settled Figure</TD>
                  <TD style="width:58%;">
                    <INPUT id="txtSettledFigure" type="text" name="txtSettledFigure" value="{format-number(@SettledFigure,//xml/@MoneyFormat)}"/>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hSettledFigure" ID="hSettledFigure" VALUE="{@SettledFigure}" />
                  </TD>
                </TR>
              </TABLE>
            </xsl:if>
          </TD>
        </TR>
        <TR CLASS="TrGameEven">
          <TD colspan="2" height="5px"></TD>
        </TR>
        <TR CLASS="TrGameOdd">
          <TD width="50%" valign="middle" align="center">
            <xsl:if test="$PERMISOACCESS = 'Yes'">
              <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="90%" >

                <TR>
                  <TD>Enable Player</TD>
                  <TD>
                    <SELECT NAME="sStatus">
                        <OPTION VALUE="E">
                          <xsl:if test="@Status='E'">
                            <xsl:attribute name="Selected">Selected</xsl:attribute>
                          </xsl:if>
                          <xsl:text>Enable</xsl:text>
                        </OPTION>
                      <OPTION VALUE="D">
                        <xsl:if test="@Status='D'">
                          <xsl:attribute name="Selected">Selected</xsl:attribute>
                        </xsl:if>
                        <xsl:text>Disable</xsl:text>
                      </OPTION>
                    </SELECT>
                  </TD>
                  <TD>
                      <INPUT TYPE="hidden" NAME="hsStatus" ID="hsStatus" VALUE="{@Status}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Enable Sports</TD>
                  <TD>
                    <INPUT id="ckSports" type="checkbox" name="ckSports" values="{@EnableSport}">
                      <xsl:if test="@EnableSport = 'True'">
                        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                      </xsl:if>
                    </INPUT>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hckSports" ID="hckSports" VALUE="{@EnableSport}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Enable Online</TD>
                  <TD>
                    <INPUT id="ckOnline" type="checkbox" name="ckOnline" values="{@EnableOnline}" >
                      <xsl:if test="@EnableOnline = 'True'">
                        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                      </xsl:if>
                    </INPUT>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hckOnline" ID="hckOnline" VALUE="{@EnableOnline}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Enable Casino</TD>
                  <TD>
                    <INPUT id="ckCasino" type="checkbox" name="ckCasino" values="{@EnableCasino}" >
                      <xsl:if test="@EnableCasino = 'True'">
                        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                      </xsl:if>
                    </INPUT>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hckCasino" ID="hckCasino" VALUE="{@EnableCasino}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Enable Horses</TD>
                  <TD>
                    <INPUT id="ckHorses" type="checkbox" name="ckHorses" values="{@EnableHorses}" >
                      <xsl:if test="@EnableHorses = 'True'">
                        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                      </xsl:if>
                    </INPUT>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hckHorses" ID="hckHorses" VALUE="{@EnableHorses}" />
                  </TD>
                </TR>
                <TR>
                  <TD>Parlay Cards</TD>
                  <TD>
                    <INPUT id="ckCards" type="checkbox" name="ckCards" values="{@EnableCards}" >
                      <xsl:if test="@EnableCards = 'True'">
                        <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                      </xsl:if>
                    </INPUT>
                  </TD>
                  <TD>
                    <INPUT TYPE="hidden" NAME="hckCards" ID="hckCards" VALUE="{@EnableCards}" />
                  </TD>
                </TR>
              </TABLE>
            </xsl:if>
          </TD>
          <TD valign="middle" align="center">
            <xsl:if test="$PERMISOLIMITS = 'Yes'">
              <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="90%" >

                <xsl:if test="$PERMISOLIMITSCREINC = 'Yes' or $PERMISOLIMITSCREDEC = 'Yes'">
                  <TR>
                    <TD>Credit Limit</TD>
                    <TD>
                      <INPUT id="txtCreLimit" type="text" name="txtCreLimit" value="{format-number(@CreditLimit,//xml/@MoneyFormat)}" maxlenght="7"/>
                    </TD>
                    <TD>
                      <INPUT TYPE="hidden" NAME="hCreditLimitOld" ID="hCreditLimitOld" VALUE="{@CreditLimit}" />
                    </TD>
                  </TR>
                </xsl:if>
                <xsl:if test="$PERMISOLIMITSWAGOINC = 'Yes' or $PERMISOLIMITSWAGODEC = 'Yes'">
                  <TR>
                    <TD>Online Max Wager</TD>
                    <TD>
                      <INPUT id="txtMaxOnLine" type="text" name="txtMaxOnLine" value="{format-number(@OnlineMaxWager,//xml/@MoneyFormat)}"/>
                    </TD>
                    <TD>
                      <INPUT TYPE="hidden" NAME="hOnlineWagerMax" ID="hOnlineWagerMax" VALUE="{@OnlineMaxWager}" />
                    </TD>
                  </TR>
                  <TR>
                    <TD>Online Min Wager</TD>
                    <TD>
                      <INPUT id="txtMinOnLine" type="text" name="txtMinOnLine" value="{format-number(@OnlineMinWager,//xml/@MoneyFormat)}"/>
                    </TD>
                    <TD>
                      <INPUT TYPE="hidden" NAME="hOnlineWagerMin" ID="hOnlineWagerMin" VALUE="{@OnlineMinWager}" />
                    </TD>
                  </TR>
                </xsl:if>
                <xsl:if test="$PERMISOLIMITSWAGLINC = 'Yes' or $PERMISOLIMITSWAGLDEC = 'Yes'">
                  <TR>
                    <TD>Max Wager</TD>
                    <TD>
                      <INPUT id="txtMax" type="text" name="txtMax" value="{format-number(@MaxWager,//xml/@MoneyFormat)}"/>
                    </TD>
                    <TD>
                      <INPUT TYPE="hidden" NAME="hWagerMax" ID="hWagerMax" VALUE="{@MaxWager}" />
                    </TD>
                  </TR>
                  <TR>
                    <TD>Min Wager</TD>
                    <TD>
                      <INPUT id="txtMin" type="text" name="txtMin" value="{format-number(@MinWager,//xml/@MoneyFormat)}"/>
                    </TD>
                    <TD>
                      <INPUT TYPE="hidden" NAME="hWagerMin" ID="hWagerMin" VALUE="{@MinWager}" />
                    </TD>
                  </TR>

                </xsl:if>
              </TABLE>
            </xsl:if>
          </TD>
        </TR>
        <TR CLASS="TrGameEven">
          <TD width="50%" valign="middle" align="center">
            <xsl:if test="$PERMISOPLAYER = 'Yes'">
              <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="90%" >
                <TR>
                  <TD>Marketing Notes</TD>
                </TR>
                <TR>
                  <TD>
                    <textarea id="txtNote01" name="txtNote01" rows="4" cols="50" maxlength="255">
                      <xsl:value-of select="@Notes1"/>
                    </textarea>
                    <INPUT TYPE="hidden" NAME="htxtNote01" ID="htxtNote01" VALUE="{@Notes1}" />
                  </TD>
                </TR>
                <TR>
                  <TD>
                    <textarea id="txtNote02" name="txtNote02" rows="4" cols="50" maxlength="255">
                      <xsl:value-of select="@Notes2"/>
                    </textarea>
                    <INPUT TYPE="hidden" NAME="htxtNote02" ID="htxtNote02" VALUE="{@Notes2}" />
                  </TD>
                </TR>
                <TR>
                  <TD>
                    <textarea id="txtNote03" name="txtNote03" rows="4" cols="50" maxlength="255">
                      <xsl:value-of select="@Notes3"/>
                    </textarea>
                    <INPUT TYPE="hidden" NAME="htxtNote03" ID="htxtNote03" VALUE="{@Notes3}" />
                  </TD>
                </TR>
              </TABLE>
            </xsl:if>
          </TD>
          <TD valign="middle" align="center">
            <TABLE CELLSPACING="0" CELLPADDING="0" BORDER="0" WIDTH="90%" >
              <TR>
                <TD>Customer Service Notes</TD>
              </TR>
              <TR>
                <TD>
                  <textarea id="txtNote04" name="txtNote04" rows="4" cols="50" maxlength="255">
                    <xsl:value-of select="@Notes4"/>
                  </textarea>
                  <INPUT TYPE="hidden" NAME="htxtNote04" ID="htxtNote04" VALUE="{@Notes4}" />
                </TD>
              </TR>
              <TR>
                <TD>
                  <textarea id="txtNote05" name="txtNote05" rows="4" cols="50" maxlength="255">
                    <xsl:value-of select="@Notes5"/>
                  </textarea>
                  <INPUT TYPE="hidden" NAME="htxtNote05" ID="htxtNote05" VALUE="{@Notes5}" />
                </TD>
              </TR>
              <TR>
                <TD>
                  <textarea id="txtNote06" name="txtNote06" rows="4" cols="50" maxlength="255">
                    <xsl:value-of select="@Notes6"/>
                  </textarea>
                  <INPUT TYPE="hidden" NAME="htxtNote06" ID="htxtNote06" VALUE="{@Notes6}" />
                </TD>
              </TR>
            </TABLE>
          </TD>
        </TR>
        <TR CLASS="TrGameBottom">
          <TD colspan="2"></TD>
        </TR>
      </TABLE>

      <xsl:for-each select="//*[position() = 12]">
        <INPUT TYPE="hidden" NAME="hRight" ID="hRight" VALUE="{@Description}" />
      </xsl:for-each>

      <xsl:if test="@Player = 'N/A'">
        <DIV>
          <INPUT TYPE="Button" VALUE="Back" LANGUAGE="javascript" ONCLICK="window.location.href='PlayerManagement.aspx'"  NAME="Back" />
        </DIV>

      </xsl:if>
      <xsl:if test="@Player != 'N/A'">
        <DIV>
          <INPUT TYPE="submit" VALUE="Save" NAME="Save" />
          <INPUT TYPE="Button" VALUE="Back" LANGUAGE="javascript" ONCLICK="window.location.href='PlayerManagement.aspx'"  NAME="Back" />
        </DIV>
      </xsl:if>
    </CENTER>


  </xsl:template>

  <xsl:template name="Permit">
    <xsl:param name="Post" />
    <xsl:for-each select="//*[position() = $Post]">
      <xsl:if test="@Allow = 'True'">Yes</xsl:if>
      <xsl:if test="@Allow = 'False'">No</xsl:if>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
