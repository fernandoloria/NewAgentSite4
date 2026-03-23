<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output  method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">
		<div class="row page-titles">
			<div class="col-md-12 col-12 align-self-center">
				<h3 class="main-title m-b-0 m-t-0">Hold Percent</h3>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date1">Initial Date:</label>
									<br></br>
									<INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{@StartDate}" />

								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date2">End Date:</label>
									<br></br>
									<INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{@EndDate}" />
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="cCurrency">Currency:</label>
									<br></br>
									<SELECT class="form-control form-control-sm"  NAME="cCurrency" OnChange="post();">
										<xsl:for-each select="currency">
											<OPTION VALUE="{@IdCurrency}">
												<xsl:if test="@AgentCurrency='True'">
													<xsl:attribute name="Selected">Selected</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@Currency" /> (<xsl:value-of select="@Symbol" />)
											</OPTION>
										</xsl:for-each>
									</SELECT>
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit" />
								</div>
							</div>
						</div>

						<h4 class="card-title">
							<xsl:value-of select="//xml/@StartDate" /> to <xsl:value-of select="//xml/@EndDate" />
						</h4>
					</div>
				</div>
			</div>
		</div>
		<xsl:for-each select="agent">
			<xsl:if test="count(detail) > 0">
				<div class="table-responsive">
					<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hover-table">
						<THEAD>
							<TR class="trAgent">
								<th colspan="5" align="center">
									Agent <xsl:value-of select="@Agent" />
								</th>
							</TR>
							<TR>
								<TH>Wager Type</TH>
								<TH>Sport</TH>
								<TH>Amount</TH>
								<TH>Win/Lost</TH>
								<TH>Hold %</TH>
							</TR>
						</THEAD>
						<xsl:for-each select="detail">
							<TR>
								<TD>
									<xsl:value-of select="@WagerType"/>
								</TD>
								<TD>
									<xsl:value-of select="@Sport"/>
								</TD>
								<TD>
									<xsl:value-of select="format-number(@Amount,'###,##0')"/>
								</TD>
								<TD>
									<xsl:value-of select="format-number(@WinLost,'###,##0')"/>
								</TD>
								<TD>
									<xsl:value-of select="format-number(@Hold,'###,##0.00')"/>%
								</TD>
							</TR>
						</xsl:for-each>
						<xsl:if test="count(detail) > 0 ">
							<TR>
								<TD>
									<STRONG>Totals</STRONG>
								</TD>
								<TD></TD>
								<TD>
									<STRONG>
										<xsl:value-of select="format-number(sum(detail/@Amount),'###,##0')" />
									</STRONG>
								</TD>
								<TD>
									<STRONG>
										<xsl:value-of select="format-number(sum(detail/@WinLost),'###,##0')" />
									</STRONG>
								</TD>
								<xsl:if test="sum(detail/@WinLost)!= 0 ">
									<TD>
										<STRONG>
											<xsl:value-of select="format-number( (sum(detail/@WinLost) *100 ) div sum(detail/@Amount), '###,##0.00')" />%
										</STRONG>
									</TD>
								</xsl:if>
								<xsl:if test="sum(detail/@WinLost)= 0 ">
									<TD></TD>
								</xsl:if>

							</TR>
						</xsl:if>
					</TABLE>
				</div>
			</xsl:if>
		</xsl:for-each>

		<xsl:if test="count(//detail) = 0">
			<div class="table-responsive">
				<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hover-table">
					<THEAD>
						<TR>
							<TH>Wager Type</TH>
							<TH>Sport</TH>
							<TH>Amount</TH>
							<TH>Win/Lost</TH>
							<TH>Hold %</TH>
						</TR>
					</THEAD>
					<TR>
						<TD colspan="5"> </TD>
					</TR>
				</TABLE>
			</div>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
