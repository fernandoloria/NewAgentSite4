<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">

		<div class="row">
			<div class="page-titles">
				<h4>Settled Figures</h4>
			</div>
		</div>


		<div class="row">
			<div class="col-12">
				<div class="card">
					<div class="card-body">
						<div class="row">
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="table-responsive">

			<TABLE class="table-dynamic table table-bordered table-striped">
				<xsl:for-each select="Agent">
					<THEAD>
						<TR class="trAgent">
							<TH colspan="5">
								Agent
								<xsl:value-of select="@Agent" disable-output-escaping="no" />
							</TH>
						</TR>
						<TR>
							<TH>Customer</TH>
							<TH>Carry Over</TH>
							<TH>This Week</TH>
							<TH>Pmts</TH>
							<TH>Current Balance</TH>
						</TR>
					</THEAD>
					<xsl:for-each select="Player">
						<TR>
							<TD>
								<xsl:value-of select="@Player" disable-output-escaping="no" />
							</TD>
							<TD>
								<xsl:value-of select="format-number(@CarryOver,'###,##0')" disable-output-escaping="no" />
							</TD>
							<TD>
								<xsl:value-of select="format-number(@ThisWeek,'###,##0')" disable-output-escaping="no" />
							</TD>
							<TD>
								<xsl:value-of select="format-number(@Ptms,'###,##0')" disable-output-escaping="no" />
							</TD>
							<TD>
								<xsl:value-of select="format-number(@Balance,'###,##0')" disable-output-escaping="no" />
							</TD>
						</TR>
					</xsl:for-each>
					<TR>
						<TD>
							SubTotals:
							<xsl:value-of select="count(Player/@Player)" />
						</TD>
						<TD>
							<xsl:value-of select="format-number(sum(Player/@CarryOver),'###,##0')" />
						</TD>
						<TD>
							<xsl:value-of select="format-number(sum(Player/@ThisWeek),'###,##0')" />
						</TD>
						<TD>
							<xsl:value-of select="format-number(sum(Player/@Ptms),'###,##0')" />
						</TD>
						<TD>
							<xsl:value-of select="format-number(sum(Player/@Balance),'###,##0')" />
						</TD>
					</TR>
				</xsl:for-each>
			</TABLE>
		</div>

	</xsl:template>

</xsl:stylesheet>
