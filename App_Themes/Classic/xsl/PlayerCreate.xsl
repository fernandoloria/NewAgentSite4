<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">

    <script language="javascript">

      function ValidateInfo(){
      var bOk = true;
      if(document.getElementById('txtPlayer').value == ''){
      alert('Player field is Necessary.');
      bOk = false;
      }

      if(document.getElementById('txtPassw').value == ''){
      alert('Password field is Necessary.');
      bOk = false;
      }

      if(document.getElementById('txtOnlinePass').value == ''){
      alert('Online Password field is Necessary.');
      bOk = false;
      }

      if(document.getElementById('txtCreditLimit').value == ''){
      alert('Credit Limit field is Necessary.');
      bOk = false;
      }

      if(document.getElementById('txtPhoneMaxWager').value == ''){
      alert('Phone Max Wager field is Necessary.');
      bOk = false;
      }

      if(document.getElementById('txtPhoneMinWager').value == ''){
      alert('Phone Min Wager field is Necessary.');
      bOk = false;
      }

      if(document.getElementById('txtOnlineMaxWager').value == ''){
      alert('Online Max Wager field is Necessary.');
      bOk = false;
      }

      if(document.getElementById('txtOnlineMinWager').value == ''){
      alert('Online Min Wager field is Necessary.');
      bOk = false;
      }

      if(bOk){
      document.forms[0].submit();
      }
      }

      function CheckPlayer()
      {
      document.getElementById('hdStep').value = '0';
      document.forms[0].submit();
      }
    </script>
    
    <input type="hidden" id="hdStep" name="hdStep" value="{//xml/@Step}" />
    <table cellspacing="5" cellpadding="1" border="0" width="100%">
      <tr>
        <td align="right" style="width:80%">
          Player:
          <input type="text" value="{//xml/@Player}" name="txtPlayer" id="txtPlayer" maxlength="10" />
        </td>
        <td>
          <input type="button" value="Check Player Availability" onclick="javascript:CheckPlayer();" />
        </td>
      </tr>
      <xsl:if test="//xml/@Step = '1'">
        <tr>
          <td colspan="2">
            <font color="red">
              Player Already Exists
            </font>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="//xml/@Step = '3'">
        <tr>
          <td colspan="2">
              Player Create Successfully!
          </td>
        </tr>
      </xsl:if>
    </table>

    <xsl:if test="//xml/@Step = '2'">
    
    <h5>Account Information</h5>
    <table cellspacing="5" cellpadding="1" border="0" width="100%" style="border:1px solid #CECECE;">
      <tr>
        <td>Under Agent:</td>
        <td>
          <select id="cmbAgent" name="cmbAgent">
            <xsl:for-each select="//Agent">
              <option value="{@IdAgent}">
                <xsl:value-of select="@Agent"/>
              </option>
            </xsl:for-each>
          </select>
        </td>
      </tr>
      <tr>
        <td style="width:20%">Password:</td>
        <td>
          <input type="text" id="txtPassw" name="txtPassw"/>
        </td>
        <td>
          <input type="checkbox" id="ckEnabled" name="ckEnabled">
            <xsl:if test="//bookdata/@DefaultEnabled = 'E'">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckEnabled">Enabled</label>
        </td>
        <td colspan="2">
          <input type="checkbox" id="ckOnline" name="ckOnline">
            <xsl:if test="//bookdata/@DefaultOnlineAccess = 'True'">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckOnline">Online</label>
        </td>
      </tr>
      <tr>
        <td>
          First Name:
        </td>
        <td>
          <input type="text" id="txtFirtName" name="txtFirtName"/>
        </td>
        <td>
          <input type="checkbox" id="ckSport" name="ckSport">
            <xsl:if test="//bookdata/@DefaultEnabledSports = 'True'">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckSport">Sports</label>
        </td>
        <td>
          <input type="checkbox" id="ckCasino" name="ckCasino">
            <xsl:if test="//bookdata/@DefaultEnabledCasino = 'True'">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckCasino">Casino</label>
        </td>
        <td>
          <input type="checkbox" id="ckRacing" name="ckRacing">
            <xsl:if test="//bookdata/@DefaultEnabledHorses = 'True'">
              <xsl:attribute name="checked">checked</xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">disabled</xsl:attribute>
            </xsl:if>
          </input>
          <label for="ckRacing">Horses</label>
        </td>
      </tr>
      <tr>
        <td>
          Last Name:
        </td>
        <td colspan="4" align="left">
          <input type="text" id="txtLastName" name="txtLastName"/>
        </td>
      </tr>
      <tr>
        <td>
          Online Password:
        </td>
        <td colspan="4" align="left">
          <input type="text" id="txtOnlinePass" name="txtOnlinePass"/>
        </td>
      </tr>
    </table>

    <h5>Wager Setting</h5>
    <table cellspacing="5" cellpadding="1" border="0" width="100%" style="border:1px solid #CECECE;">
      <tr>
        <td style="width:20%">Credit Limit:</td>
        <td>
          <input type="text" id="txtCreditLimit" name="txtCreditLimit"/>
        </td>
      </tr>
      <tr>
        <td>MLB Line:</td>
        <td>
          <select id="cmbMLBLine" name="cmbMLBLine">
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <option value="N">
              <xsl:if test="//bookdata/@DefaultMLBLine = 'N'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              Normal
            </option>
            <option value="W">
              <xsl:if test="//bookdata/@DefaultMLBLine = 'W'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              Wide
            </option>
            <option value="Y">
              <xsl:if test="//bookdata/@DefaultMLBLine = 'Y'">
                <xsl:attribute name="selected">selected</xsl:attribute>
              </xsl:if>
              New York
            </option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Pitcher Default:</td>
        <td>
          <select id="cmbPitcher" name="cmbPitcher">
            <option value="0">Action</option>
            <option value="1">Visitor</option>
            <option value="2">Home</option>
            <option value="3">Listed</option>
            <option value="4">Same</option>
          </select>
        </td>
      </tr>
      <tr>
        <td>Profiles:</td>
        <td>
          <select id="cmbProfile" name="cmbProfile">
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:for-each select="//game">
              <option value="{@IdProfile}">
                <xsl:if test="//bookdata/@DefaultProfile = @IdProfile">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@ProfileName"/>
              </option>
            </xsl:for-each>
          </select>
        </td>
      </tr>
      <tr>
        <td>Profiles Limits:</td>
        <td>
          <select id="cmbProfileLimits" name="cmbProfileLimits">
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:for-each select="//right">
              <option value="{@IdProfileLimit}">
                <xsl:if test="//bookdata/@DefaultProfileLimit = @IdProfileLimit">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@ProfileLimitName"/>
              </option>
            </xsl:for-each>
          </select>
        </td>
      </tr>
      <tr>
        <td>Line Type:</td>
        <td>
          <select id="cmbLine" name="cmbLine">
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="disabled">true</xsl:attribute>
            </xsl:if>
            <xsl:for-each select="//line">
              <option value="{@IdLineType}">
                <xsl:if test="//bookdata/@DefaultLineType = @IdLineType">
                  <xsl:attribute name="selected">selected</xsl:attribute>
                </xsl:if>
                <xsl:value-of select="@LineTypeDescription"/>
              </option>
            </xsl:for-each>
          </select>
        </td>
      </tr>
    </table>

    <h5>Phone Setting</h5>
    <table cellspacing="5" cellpadding="1" border="0" width="100%" style="border:1px solid #CECECE;">
      <tr>
        <td style="width:20%">Phone Max Wager</td>
        <td>
          <input type="text" id="txtPhoneMaxWager" name="txtPhoneMaxWager">
            <xsl:if test="//bookdata/@DefaultMaxWager != ''">
              <xsl:attribute name="value">
                <xsl:value-of select="format-number(//bookdata/@DefaultMaxWager,//xml/@MoneyFormat)"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="readonly">readonly</xsl:attribute>
            </xsl:if>
          </input>
        </td>
      </tr>
      <tr>
        <td>Phone Min Wager</td>
        <td>
          <input type="text" id="txtPhoneMinWager" name="txtPhoneMinWager">
            <xsl:if test="//bookdata/@DefaultMinWager != ''">
              <xsl:attribute name="value">
                <xsl:value-of select="format-number(//bookdata/@DefaultMinWager,//xml/@MoneyFormat)"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="readonly">readonly</xsl:attribute>
            </xsl:if>
          </input>
        </td>
      </tr>
    </table>

    <h5>Online Setting</h5>
    <table cellspacing="5" cellpadding="1" border="0" width="100%" style="border:1px solid #CECECE;">
      <tr>
        <td style="width:20%">Online Max Wager</td>
        <td>
          <input type="text" id="txtOnlineMaxWager" name="txtOnlineMaxWager">
            <xsl:if test="//bookdata/@DefaultMaxWagerOnline != ''">
              <xsl:attribute name="value">
                <xsl:value-of select="format-number(//bookdata/@DefaultMaxWagerOnline,//xml/@MoneyFormat)"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="readonly">readonly</xsl:attribute>
            </xsl:if>
          </input>
        </td>
      </tr>
      <tr>
        <td>Online Min Wager</td>
        <td>
          <input type="text" id="txtOnlineMinWager" name="txtOnlineMinWager">
            <xsl:if test="//bookdata/@DefaultMinWagerOnline != ''">
              <xsl:attribute name="value">
                <xsl:value-of select="format-number(//bookdata/@DefaultMinWagerOnline,//xml/@MoneyFormat)"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="readonly">readonly</xsl:attribute>
            </xsl:if>
          </input>
        </td>
      </tr>
      <tr>
        <td>
          Online Message
        </td>
        <td>
          <input type="text" id="txtOnlineMessage" name="txtOnlineMessage" maxlength="100" size="80">
            <xsl:if test="//bookdata/@DefaultOnlineMessage != ''">
              <xsl:attribute name="value">
                <xsl:value-of select="//bookdata/@DefaultOnlineMessage"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="//@UseOnlyDefaultData = 'True'">
              <xsl:attribute name="readonly">readonly</xsl:attribute>
            </xsl:if>
          </input>
        </td>
      </tr>
    </table>
    <br />
    <input type="button" value="Add Player" onclick="javascript:ValidateInfo();" />
      
    </xsl:if>
  </xsl:template>
</xsl:stylesheet>
