<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html" indent="no" encoding="UTF-8" />

    <xsl:template match="/*">

        <SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
            function CloseW() {

            }

        </SCRIPT>
        <center>
            <div class="table-responsive">
                <TABLE class="table color-table success-table table-bordered table-striped table-sm">
                    <TR>
                        <TD colspan="2">
                            Game Score Ticket #
                            <xsl:value-of select="//xml/@TicketNumber" />
                        </TD>
                    </TR>
                    <xsl:for-each select="//detail">
                        <TR>
                            <TD>
                                <xsl:value-of disable-output-escaping="yes" select="@Description" />
                                <BR></BR>
                                <xsl:value-of disable-output-escaping="yes" select="@Result" />
                            </TD>
                            <TD WIDTH="50%">
                                <TABLE class="table color-table success-table table-bordered table-striped table-sm">
                                    <thead>
                                    <TR>
                                        <TH width="50%">
                                            - GUEST -
                                            <BR />
                                            <xsl:value-of disable-output-escaping="yes" select="@VisitorTeam" />
                                        </TH>
                                        <TH>
                                            - HOME -
                                            <BR />
                                            <xsl:value-of disable-output-escaping="yes" select="@HomeTeam" />
                                        </TH>
                                    </TR>
                                    </thead>
                                    <TR class="TrScore">
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="@VisitorScore" />
                                        </TD>
                                        <TD>
                                            <xsl:value-of disable-output-escaping="yes" select="@HomeScore" />
                                        </TD>
                                    </TR>
                                </TABLE>
                            </TD>
                        </TR>
                    </xsl:for-each>
                    <TR>
                        <TD colspan="2"></TD>
                    </TR>
                </TABLE>
            </div>
            <div>
                <input type="button" class="btn btn-default" value="Close" data-bs-dismiss="modal" />
            </div>
        </center>
    </xsl:template>

</xsl:stylesheet>
