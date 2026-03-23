<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">
        <SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
            function ViewBOW() {
                var cTrans = document.getElementById('sTransac');
                var oDiv = document.getElementById('chkBOW');
                if (cTrans.value == 'C') {
                    oDiv.style.display = 'block';
                } else {
                    oDiv.style.display = 'none';
                }
				changeDescription();
				
            }
			
			function changeDescription(){
			    var cTrans = document.getElementById('sTransac');
			    var type = cTrans.value;
				switch(type) {
				    case 'A':
					    document.getElementById('txtDescription').value = 'ADJUSTMENT';
					    break;
					case 'C':
					    document.getElementById('txtDescription').value = 'PAYMENT';
					    break;
					case 'H':
					    document.getElementById('txtDescription').value = 'HORSE ADJUSTMENT';
					    break;
					case 'D':
					    document.getElementById('txtDescription').value = 'PAYMENT';
					    break
				    case 'R':
					    document.getElementById('txtDescription').value = 'PAYMENT';
					    break
					case 'P':
					    document.getElementById('txtDescription').value = 'FREE PLAY';
					    break
					}
			}
			
			
		$( document ).ready(function() {
            changeDescription();
        });

        </SCRIPT>

        
<div class="row page-titles">
        <div class="col-md-12 col-12 align-self-center">
            <h3 class="main-title m-b-0 m-t-0">Player Payment</h3>          
        </div>
    </div>
        <input type="hidden" value="{@IdPlayer}" name="hPlayer" />
        <input type="hidden" value="{@CurrentBalance}" name="hBalance" />
        <input type="hidden" value="{@FreePlayAmount}" name="hFreePlay" />

        <div class="row">
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <h3 class="box-title m-b-0">Player Payment</h3>
                        <xsl:call-template name="Info" />
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="card">
                    <div class="card-body">
                        <h3 class="box-title m-b-0">Player Statistics</h3>
                        <xsl:call-template name="Account" />
                    </div>
                </div>
            </div>
        </div>
        <center>
            <xsl:if test="@Player != 'N/A'">
                
                <input type="button" class="btn btn-primary" value="Submit" onclick="respConfirm();" />
                <input type="button" class="btn btn-danger" value="Back" onclick="window.history.back(1);" />
            </xsl:if>
            <xsl:if test="@Player = 'N/A'">
                <input type="button" class="btn btn-danger" value="Back" onclick="window.history.back(1);" />
            </xsl:if>
        </center>

    </xsl:template>

    <xsl:template name="Info">
        <div class="form-horizontal">
            <div class="form-group row">
                <label for="Player" class="col-sm-4 text-right control-label col-form-label">Account</label>
                <div class="col-sm-8" style="padding-top:6px;">
                    <xsl:value-of select="@Player" />
                </div>
            </div>
            <div class="form-group row">
                <label for="Password" class="col-sm-4 text-right control-label col-form-label">Password</label>
                <div class="col-sm-8" style="padding-top:6px;">
                    <xsl:value-of select="@Password" />
                </div>
            </div>
            <div class="form-group row">
                <label for="txtAmount" class="col-sm-4 text-right control-label col-form-label">Amount</label>
                <div class="col-sm-8">
                    <input TYPE="text" class="form-control form-control-sm" maxlenght="10" name="txtAmount" value="0.00" />
                </div>
            </div>
            <div class="form-group row" style="display:none">
                <label for="sMethod" class="col-sm-4 text-right control-label col-form-label">Method</label>
                <div class="col-sm-8">
                    <SELECT class="form-control form-control-sm" NAME="sMethod">
                    <xsl:for-each select="PMCombo">
                      <xsl:choose>
                        <xsl:when test="@Id = 2">
                          <OPTION value="{@Id}" selected="selected">
                            <xsl:value-of select="@Description"/>
                          </OPTION>
                        </xsl:when >
                        <xsl:otherwise>
                          <OPTION value="{@Id}">
                            <xsl:value-of select="@Description"/>
                          </OPTION>
                        </xsl:otherwise>
                      </xsl:choose>
                    </xsl:for-each>
                  </SELECT>
                </div>
            </div>
			<div class="form-group row">
                <label for="sTransac" class="col-sm-4 text-right control-label col-form-label">Transaction Type</label>
                <div class="col-sm-8">
                    <SELECT class="form-control form-control-sm" NAME="sTransac" id="sTransac" OnChange="ViewBOW();">
                      <xsl:for-each select="combobox">
						  <xsl:choose>
                        <xsl:when test="@Value = 'P'">
                          <OPTION value="{@Value}">
                          <xsl:value-of select="@Text"/>
                        </OPTION>
                        </xsl:when >
                        <xsl:otherwise>
                          <OPTION value="{@Value}">
                          <xsl:value-of select="@Text"/>
                        </OPTION>
                        </xsl:otherwise>
                      </xsl:choose>
                        
                      </xsl:for-each>
                    </SELECT>
                    <input type="hidden" name="txtFee" value="0.00" />
                    <input type="hidden" name="txtBonus" value="0.00" />
                </div>
            </div>
            <div class="form-group row">
                <label for="txtDescription"  class="col-sm-4 text-right control-label col-form-label">Description</label>
                <div class="col-sm-8">
                    <input TYPE="text" id="txtDescription" class="form-control form-control-sm" name="txtDescription" value="Agent Payment" />
                </div>
            </div>
            <div class="form-group row" style="display:none;">
                <label for="txtAmount" class="col-sm-4 text-right control-label col-form-label">Reference</label>
                <div class="col-sm-8">
                    <textarea class="form-control form-control-sm" name="txtReference" />
                </div>
            </div>
            
            <div class="form-group row">
                <label for="txtAmount" class="col-sm-4 text-right control-label col-form-label"> </label>
                <div class="col-sm-8">
                    <div id="chkBOW" style="display:none;">
                        <input type="checkbox" name="chBOW">
                        <!--<xsl:attribute name="checked">CHECKED</xsl:attribute>-->
                        </input>Add to BOW
                    </div>
                </div>
            </div>
        </div>
        <!--<TABLE CELLSPACING="0" CELLPADDING="1" BORDER="0" WIDTH="100%">
           <TR>
            <TD>Fee</TD>
            <TD><input TYPE="text" class="form-control form-control-sm" maxlenght="10" name="txtFee" value="0.00"/></TD>
           </TR>
           <TR>
            <TD>Bonus</TD>
            <TD><input TYPE="text" class="form-control form-control-sm" maxlenght="10" name="txtBonus" value="0.00"/></TD>
           </TR>
            <TR>
            <TD align="right">
                <INPUT style="WIDTH: 100px" TITLE="The Format is mm/dd/yyyy ej: 7/15/2002 for July 15 2002" TYPE="text" class="form-control form-control-sm" NAME="Date1" value="{//DATA/@DATE}" />
                    <A HREF="#" onClick="JavaScript:cal.select(document.forms[0].Date1,'anchor1','MM/dd/yyyy'); return false;" NAME="anchor1" ID="anchor1">
                        <IMG SRC="images/calendar2.gif" border="0" width="20"/>
                    </A>
            </TD>
            <TD>
            
            </TD>
            </TR>
        </TABLE>-->
    </xsl:template>

    <xsl:template name="Account">
        <div class="form-horizontal">
            <div class="form-group row">
                <label for="Player" class="col-sm-4 text-right control-label col-form-label">Credit Limit:</label>
                <div class="col-sm-8" style="padding-top:6px;">
                    <xsl:value-of select="format-number(@CreditLimit,'###,##0')" />
                </div>
            </div>
            <div class="form-group row">
                <label for="Player" class="col-sm-4 text-right control-label col-form-label">Current Balance:</label>
                <div class="col-sm-8" style="padding-top:6px;">
                    <xsl:value-of select="format-number(@CurrentBalance,'###,##0')" />
                </div>
            </div>
            <div class="form-group row">
                <label for="Player" class="col-sm-4 text-right control-label col-form-label">Amount At Risk:</label>
                <div class="col-sm-8" style="padding-top:6px;">
                    <xsl:value-of select="format-number(@AmountAtRisk,'###,##0')" />
                </div>
            </div>
            <div class="form-group row">
                <label for="Player" class="col-sm-4 text-right control-label col-form-label">Avail Balance:</label>
                <div class="col-sm-8" style="padding-top:6px;">
                    <xsl:choose>
                        <xsl:when test="@CurrentBalance = '0'">
                            <xsl:value-of select="format-number(@CreditLimit - @AmountAtRisk,'###,##0')" />
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="format-number((@CreditLimit + @CurrentBalance) - @AmountAtRisk,'###,##0')" />
                        </xsl:otherwise>
                    </xsl:choose>
                </div>
            </div>
            <div class="form-group row">
                <label for="Player" class="col-sm-4 text-right control-label col-form-label">Free Play Amount:</label>
                <div class="col-sm-8" style="padding-top:6px;">
                    <xsl:value-of select="format-number(@FreePlayAmount,'###,##0')" />
                </div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
