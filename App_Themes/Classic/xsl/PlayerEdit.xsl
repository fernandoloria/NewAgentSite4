<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

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
        
        <div class="row">
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <h3 class="box-title m-b-0">Edit Player:
                            <xsl:value-of disable-output-escaping="yes" select="@Player" /> </h3>
                        <xsl:if test="$PERMISOPLAYER = 'Yes'">
                            <div class="form-horizontal">
                                <div class="form-group row">
                                    <label for="txtName" class="col-sm-4 text-right control-label col-form-label">Name</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtName" TYPE="text" class="form-control form-control-sm" name="txtName" value="{@Name}" />
                                        <INPUT TYPE="hidden" NAME="htxtName" ID="htxtName" VALUE="{@Name}" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="txtLastName" class="col-sm-4 text-right control-label col-form-label">Middle Name</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtLastName" TYPE="text" class="form-control form-control-sm" name="txtLastName" value="{@LastName}" />
                                        <INPUT TYPE="hidden" NAME="htxtLastName" ID="htxtLastName" VALUE="{@LastName}" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="txtLastName2" class="col-sm-4 text-right control-label col-form-label">Last Name</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtLastName2" TYPE="text" class="form-control form-control-sm" name="txtLastName2" value="{@LastName2}" />
                                        <INPUT TYPE="hidden" NAME="htxtLastName2" ID="htxtLastName2" VALUE="{@LastName2}" />
                                    </div>
                                </div>
                                <div class="form-group row" style="display:none">
                                    <label for="txtPass" class="col-sm-4 text-right control-label col-form-label">Password</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtPass" TYPE="text" class="form-control form-control-sm" name="txtPass" value="{@Password}" />
                                        <INPUT TYPE="hidden" NAME="htxtPass" ID="htxtPass" VALUE="{@Password}" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="txtPassOnline" class="col-sm-4 text-right control-label col-form-label">Online Password</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtPassOnline" TYPE="text" class="form-control form-control-sm" name="txtPassOnline" maxlength="20" value="{@OnlinePassword}" />
                                        <INPUT TYPE="hidden" NAME="htxtPassOnline" ID="htxtPassOnline" VALUE="{@OnlinePassword}" />
                                    </div>
                                </div>
                            </div>
                        </xsl:if>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <h3 class="box-title m-b-0">Edit Limits:</h3>
                        <div class="form-horizontal">
                            <xsl:if test="$PERMISOCHANGETEMP = 'Yes'">
                                <div class="form-group row">
                                    <label for="txtTempCredit" class="col-sm-4 text-right control-label col-form-label">Temp Credit</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtTempCredit" TYPE="text" class="form-control form-control-sm" name="txtTempCredit" value="{format-number(@TempCredit,'#####0')}" />
                                        <INPUT TYPE="hidden" NAME="hTempCredit" ID="hTempCredit" VALUE="{@TempCredit}" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="txtTempCreditExp" class="col-sm-4 text-right control-label col-form-label">Temp Credit Expire</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtTempCreditExp" TITLE="The Format is mm/dd/yyyy ej: 7/15/2002 for July 15 2002" TYPE="text" class="form-control form-control-sm" name="txtTempCreditExp" value="{@TempCreditExpire}" />
                                        <INPUT TYPE="hidden" NAME="hTempCreditExp" ID="hTempCreditExp" VALUE="{@TempCreditExpire}" />
                                    </div>
                                </div>
                            </xsl:if>
                            <xsl:if test="$PERMISOPLAYER = 'Yes'">
                                <div class="form-group row">
                                    <label for="txtSettledFigure" class="col-sm-4 text-right control-label col-form-label">Settled Figure</label>
                                    <div class="col-sm-8">
                                        <INPUT id="txtSettledFigure" TYPE="text" class="form-control form-control-sm" name="txtSettledFigure" value="{format-number(@SettledFigure,'#####0')}" />
                                        <INPUT TYPE="hidden" NAME="hSettledFigure" ID="hSettledFigure" VALUE="{@SettledFigure}" />
                                    </div>
                                </div>
                            </xsl:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="row">
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <div class="form-horizontal">
                            <xsl:if test="$PERMISOACCESS = 'Yes'">
                                <div class="form-group row">
                                    <label for="sStatus" class="col-sm-4 text-right control-label col-form-label">Enable Player</label>
                                    <div class="col-sm-8">
                                        <SELECT class="form-control form-control-sm" NAME="sStatus">
                                        <xsl:for-each select="//status">
                                          <OPTION VALUE="{@Value}">
                                            <xsl:if test="@Selected='1'">
                                              <xsl:attribute name="Selected">Selected</xsl:attribute>
                                            </xsl:if>
                                            <xsl:value-of select="@Text" />
                                          </OPTION>
                                        </xsl:for-each>
                                      </SELECT>
                                        <xsl:for-each select="//status[@Selected='1']">
                                            <INPUT TYPE="hidden" NAME="hsStatus" ID="hsStatus" VALUE="{@Value}" />
                                        </xsl:for-each>
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ckSports" class="col-sm-4 text-right control-label col-form-label">Enable Sports</label>
                                    <div class="col-sm-8">
                                        <INPUT id="ckSports" type="checkbox" data-toggle="toggle" data-size="small" name="ckSports" values="{@EnableSport}">
                                        <xsl:if test="@EnableSport = 'True'">
                                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                                        </xsl:if>
                                        </INPUT>
                                        <INPUT TYPE="hidden" NAME="hckSports" ID="hckSports" VALUE="{@EnableSport}" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ckOnline" class="col-sm-4 text-right control-label col-form-label">Enable Online</label>
                                    <div class="col-sm-8">
                                        <INPUT id="ckOnline" type="checkbox" data-toggle="toggle" data-size="small" name="ckOnline" values="{@EnableOnline}">
                                        <xsl:if test="@EnableOnline = 'True'">
                                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                                        </xsl:if>
                                        </INPUT>
                                        <INPUT TYPE="hidden" NAME="hckOnline" ID="hckOnline" VALUE="{@EnableOnline}" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ckOnline" class="col-sm-4 text-right control-label col-form-label">Enable Casino</label>
                                    <div class="col-sm-8">
                                        <INPUT id="ckCasino" type="checkbox" data-toggle="toggle" data-size="small" name="ckCasino" values="{@EnableCasino}">
                                        <xsl:if test="@EnableCasino = 'True'">
                                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                                        </xsl:if>
                                        </INPUT>
                                        <INPUT TYPE="hidden" NAME="hckCasino" ID="hckCasino" VALUE="{@EnableCasino}" />
                                    </div>
                                </div>
                                <div class="form-group row">
                                    <label for="ckHorses" class="col-sm-4 text-right control-label col-form-label">Enable Horses</label>
                                    <div class="col-sm-8">
                                        <INPUT id="ckHorses" type="checkbox" data-toggle="toggle" data-size="small" name="ckHorses" values="{@EnableHorses}">
                                        <xsl:if test="@EnableHorses = 'True'">
                                            <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                                        </xsl:if>
                                        </INPUT>
                                        <INPUT TYPE="hidden" NAME="hckHorses" ID="hckHorses" VALUE="{@EnableHorses}" />
                                    </div>
                                </div>
                                <div class="form-group row" style="display:none">
                                    <label for="ckCards" class="col-sm-4 text-right control-label col-form-label">Parlay Cards</label>
                                    <div class="col-sm-8">
                                        <div class="checkbox checkbox-success">
                                            <INPUT id="ckCards" type="checkbox" data-toggle="toggle" data-size="small" name="ckCards" values="{@EnableCards}">
                                            <xsl:if test="@EnableCards = 'True'">
                                                <xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
                                            </xsl:if>
                                            </INPUT>
                                            <INPUT TYPE="hidden" NAME="hckCards" ID="hckCards" VALUE="{@EnableCards}" />
                                        </div>
                                    </div>
                                </div>
                            </xsl:if>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <div class="form-horizontal">
                            <xsl:if test="$PERMISOLIMITS = 'Yes'">
                                <xsl:if test="$PERMISOLIMITSCREINC = 'Yes' or $PERMISOLIMITSCREDEC = 'Yes'">
                                    <div class="form-group row">
                                        <label for="txtCreLimit" class="col-sm-4 text-right control-label col-form-label">Credit Limit</label>
                                        <div class="col-sm-8">
                                            <INPUT id="txtCreLimit" TYPE="text" class="form-control form-control-sm" name="txtCreLimit" value="{format-number(@CreditLimit,'#####0')}" />
                                            <INPUT TYPE="hidden" NAME="hCreditLimitOld" ID="hCreditLimitOld" VALUE="{@CreditLimit}" />
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test="$PERMISOLIMITSWAGOINC = 'Yes' or $PERMISOLIMITSWAGODEC = 'Yes'">
                                    <div class="form-group row">
                                        <label for="txtMaxOnLine" class="col-sm-4 text-right control-label col-form-label">Online Max Wager</label>
                                        <div class="col-sm-8">
                                            <INPUT id="txtMaxOnLine" TYPE="text" class="form-control form-control-sm" name="txtMaxOnLine" value="{format-number(@OnlineMaxWager,'#####0')}" />
                                            <INPUT TYPE="hidden" NAME="hOnlineWagerMax" ID="hOnlineWagerMax" VALUE="{@OnlineMaxWager}" />
                                        </div>
                                    </div>
                                    <div class="form-group row">
                                        <label for="txtMinOnLine" class="col-sm-4 text-right control-label col-form-label">Online Min Wager</label>
                                        <div class="col-sm-8">
                                            <INPUT id="txtMinOnLine" TYPE="text" class="form-control form-control-sm" name="txtMinOnLine" value="{format-number(@OnlineMinWager,'#####0')}" />
                                            <INPUT TYPE="hidden" NAME="hOnlineWagerMin" ID="hOnlineWagerMin" VALUE="{@OnlineMinWager}" />
                                        </div>
                                    </div>
                                </xsl:if>
                                <xsl:if test="$PERMISOLIMITSWAGLINC = 'Yes' or $PERMISOLIMITSWAGLDEC = 'Yes'">
                                    <div class="form-group row" style="display:none;">
                                        <label for="txtMax" class="col-sm-4 text-right control-label col-form-label">Max Wager</label>
                                        <div class="col-sm-8">
                                            <INPUT id="txtMax" TYPE="text" class="form-control form-control-sm" name="txtMax" value="{format-number(@MaxWager,'#####0')}" />
                                            <INPUT TYPE="hidden" NAME="hWagerMax" ID="hWagerMax" VALUE="{@MaxWager}" />
                                        </div>
                                    </div>
                                    <div class="form-group row" style="display:none;">
                                        <label for="txtMin" class="col-sm-4 text-right control-label col-form-label">Min Wager</label>
                                        <div class="col-sm-8">
                                            <INPUT id="txtMin" TYPE="text" class="form-control form-control-sm" name="txtMin" value="{format-number(@MinWager,'#####0')}" />
                                            <INPUT TYPE="hidden" NAME="hWagerMin" ID="hWagerMin" VALUE="{@MinWager}" />
                                        </div>
                                    </div>
                                </xsl:if>
                            </xsl:if>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <CENTER>
            <xsl:for-each select="//*[position() = 12]">
                <INPUT TYPE="hidden" NAME="hRight" ID="hRight" VALUE="{@Description}" />
            </xsl:for-each>

            <xsl:if test="@Player = 'N/A'">
                <DIV>
                    <INPUT TYPE="Button" VALUE="Back" LANGUAGE="javascript" ONCLICK="window.location.href='PlayerManagement.aspx'" NAME="Back" />
                </DIV>

            </xsl:if>
            <xsl:if test="@Player != 'N/A'">
                <DIV>
                    <button type="submit" class="btn btn-success waves-effect waves-light m-r-10">Save</button>
                    <button TYPE="button" class="btn btn-inverse waves-effect waves-light" LANGUAGE="javascript" ONCLICK="window.location.href='PlayerManagement.aspx'">Back</button>
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
