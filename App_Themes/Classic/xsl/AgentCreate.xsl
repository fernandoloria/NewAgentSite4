<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output  method="html" indent="no" encoding="UTF-8" />

  <xsl:template match="//xml">
    <script language="javascript">

      function ValidateInfo(){
      var bOk = true;
      if(document.getElementById('txtAgent').value == ''){
      alert('Agent field is Necessary.');
      bOk = false;
      }
      if(document.getElementById('txtName').value == ''){
      alert('Name field is Necessary.');
      bOk = false;
      }
      if(document.getElementById('txtPassw').value == ''){
      alert('Password field is Necessary.');
      bOk = false;
      }

      if(bOk){
      document.forms[0].submit();
      }
      }

      function CheckAgent()
      {
      document.getElementById('hdStep').value = '0';
      document.forms[0].submit();
      }
    </script>

      <input type="hidden" id="hdStep" name="hdStep" value="{//xml/@Step}" />
    <table cellspacing="5" cellpadding="1" border="0" width="100%">
      <tr>
        <td align="right" style="width:80%">
          Agent:
          <input type="text" value="{//xml/@Agent}" name="txtAgent" id="txtAgent" maxlength="10" />
        </td>
        <td>
          <input type="button" value="Check Agent Availability" onclick="javascript:CheckAgent();" />
        </td>
      </tr>
      <xsl:if test="//xml/@Step = '1'">
        <tr>
          <td colspan="2">
            <font color="red">
              Agent Already Exists
            </font>
          </td>
        </tr>
      </xsl:if>
      <xsl:if test="//xml/@Step = '3'">
        <tr>
          <td colspan="2">
            Agent Create Successfully!
          </td>
        </tr>
      </xsl:if>
    </table>

    <xsl:if test="//xml/@Step = '2'">
      <h5>Agent Information</h5>
      <table cellspacing="5" cellpadding="1" border="0" width="100%" style="border:1px solid #CECECE;">
        <tr>
          <td>
            Name:
          </td>
          <td>
            <input type="text" id="txtName" name="txtName"/>
          </td>
        </tr>
        <tr>
          <td>
            Password:
          </td>
          <td>
            <input type="text" id="txtPassw" name="txtPassw"/>
          </td>
        </tr>
        <tr>
          <td>
            Under Agent:
          </td>
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
          <td colspan="2">
            <input type="checkbox" id="ckEnabled" name="ckEnabled">Enabled</input>
          </td>
        </tr>
        <tr>
          <td colspan="2">
            <input type="checkbox" id="ckXfer" name="ckXfer">Xfer</input>
          </td>
        </tr>
      </table>
      <br />
      <input type="button" value="Add Agent" onclick="javascript:ValidateInfo();" />
    </xsl:if>
    </xsl:template>
</xsl:stylesheet>
