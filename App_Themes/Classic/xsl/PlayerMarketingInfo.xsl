<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="//xml">
        <div align="center">
            <h3>- Player Marketing Information -</h3>
        </div>
        <br />
        <center>
            <xsl:if test="@AgentUpdateMarkInfo = 'False'">
                <TABLE class="table table-striped table-bordered" width="100%">
                    <tr>
                        <td>
                            Player:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Player" />
                        </td>
                        <td colspan="3">
                            Name:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Name" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@LastName" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@LastName2" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            Address:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Address1" />
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Address2" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            City:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@City" />
                        </td>
                        <td>
                            State:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@State" />
                        </td>
                        <td>
                            Country:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Country" />
                        </td>
                        <td>
                            Zip:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Zip" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            Email:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Email" />
                        </td>
                        <td colspan="2">
                            Flag Message:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@FlagMessage" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            Online Message:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@OnlineMessage" />
                        </td>
                    </tr>
                </TABLE>
            </xsl:if>

            <xsl:if test="@AgentUpdateMarkInfo = 'True'">
                <TABLE class="table table-striped table-bordered" width="100%">
                    <tr>
                        <td>
                            <input type="hidden" name="hPlayer" id="hPlayer" value="{@Player}" /> Player:
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="@Player" />
                        </td>
                        <td>
                            <input type="hidden" name="hName" id="hName" value="{@Name}" /> Name:
                            <input TYPE="text" class="form-control form-control-sm" id="txtName" name="txtName" value="{@Name}" />
                        </td>
                        <td>
                            <input type="hidden" name="hLastName" id="hLastName" value="{@LastName}" />
                            <input TYPE="text" class="form-control form-control-sm" id="txtLastName" name="txtLastName" value="{@LastName}" />
                        </td>
                        <td>
                            <input type="hidden" name="hLastName2" id="hLastName2" value="{@LastName2}" />
                            <input TYPE="text" class="form-control form-control-sm" id="txtLastName2" name="txtLastName2" value="{@LastName2}" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <input type="hidden" name="hAddress1" id="hAddress1" value="{@Address1}" />
                            <input type="hidden" name="hAddress2" id="hAddress2" value="{@Address2}" /> Address:
                            <input TYPE="text" class="form-control form-control-sm" name="txtAddress1" id="txtAddress1" value="{@Address1}" />
                            <input TYPE="text" class="form-control form-control-sm" name="txtAddress2" id="txtAddress2" value="{@Address2}" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <input type="hidden" name="hCity" id="hCity" value="{@City}" /> City:
                            <input TYPE="text" class="form-control form-control-sm" name="txtCity" id="txtCity" value="{@City}" />
                        </td>
                        <td>
                            <input type="hidden" name="hState" id="hState" value="{@State}" /> State:
                            <input TYPE="text" class="form-control form-control-sm" name="txtState" id="txtState" value="{@State}" />
                        </td>
                        <td>
                            <input type="hidden" name="hCountry" id="hCountry" value="{@Country}" /> Country:
                            <input TYPE="text" class="form-control form-control-sm" name="txtCountry" id="txtCountry" value="{@Country}" />
                        </td>
                        <td>
                            <input type="hidden" name="hZip" id="hZip" value="{@Zip}" /> Zip:
                            <input TYPE="text" class="form-control form-control-sm" name="txtZip" id="txtZip" value="{@Zip}" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                            <input type="hidden" name="hEmail" id="hEmail" value="{@Email}" /> Email:
                            <input TYPE="text" class="form-control form-control-sm" name="txtEmail" id="txtEmail" value="{@Email}" />
                        </td>
                        <td colspan="2">
                            <input type="hidden" name="hFlagMessage" id="hFlagMessage" value="{@FlagMessage}" /> Flag Message:<input TYPE="text" class="form-control form-control-sm" name="txtFlagMessage" id="txtFlagMessage" value="{@FlagMessage}" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <input type="hidden" name="hOnlineMessage" id="hOnlineMessage" value="{@OnlineMessage}" /> Online Message:<input TYPE="text" class="form-control form-control-sm" name="txtOnlineMessage" id="txtOnlineMessage" value="{@OnlineMessage}" />
                        </td>
                    </tr>
                </TABLE>
            </xsl:if>

            <br />
            <div align="center">
                <xsl:if test="@AgentUpdateMarkInfo = 'True'">
                    <input type="button" value="Update" onclick="MarkInfoUpdate();" />
                    <xsl:text> </xsl:text>
                </xsl:if>
                <input type="button" value="Close" data-bs-dismiss="modal" />
            </div>
        </center>
    </xsl:template>

</xsl:stylesheet>
