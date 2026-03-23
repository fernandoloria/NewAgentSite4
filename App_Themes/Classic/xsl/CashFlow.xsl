<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">
		<div class="row">
			<div class="page-titles">
				<h4>Players Standing</h4>
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
									<SELECT class="form-control form-control-sm" NAME="cCurrency" OnChange="post();">
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
								<INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:24px;" value="Submit" name="Submit" />
							</div>
						</div>
						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Type">Transaction Type:</label>
									<br></br>
									<SELECT class="form-control form-control-sm" NAME="Type" OnChange="post();">
										<xsl:for-each select="combobox">
											<OPTION VALUE="{@Value}">
												<xsl:if test="@Selected='1'">
													<xsl:attribute name="Selected">Selected</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@Text" />
											</OPTION>
										</xsl:for-each>
									</SELECT>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>



		<h4 class="card-title">
			<xsl:value-of select="@StartDate" /> to
			<xsl:value-of select="@EndDate" />
		</h4>
		<xsl:for-each select="agent">
			<xsl:if test="count(detail) > 0">
				<div class="table-responsive">
					<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
						<THEAD>
							<TR class="trAgent">
								<TH colspan="7">
									Agent
									<xsl:value-of select="@Agent" />
								</TH>
							</TR>
							<TR>
								<TH>Player</TH>
								<TH>Placed</TH>
								<th class="d-none d-lg-table-cell">Payment</th>
								<th class="d-md-none">Payment</th>
								<th>Reference</th>
								<th class="d-none d-lg-table-cell">Description</th>
								<TH>Amount</TH>
							</TR>
						</THEAD>
						<xsl:for-each select="detail">
							<tr>
								<td>
									<xsl:value-of select="@Player"/>
								</td>
								<td>
									<xsl:call-template name="convertcommas">
										<xsl:with-param name="text" select="@Placed"/>
									</xsl:call-template>
								</td>
								<td class="d-none d-lg-table-cell">
									<xsl:value-of select="@PaymentMethod"/>
								</td>
								<td class="d-md-none">
									<xsl:value-of select="@Description"/>
									<br/>
									<xsl:value-of select="@PaymentMethod"/>
								</td>
								<td>
									<xsl:value-of select="@Reference"/>
								</td>
								<td class="d-none d-lg-table-cell">
									<xsl:value-of select="@Description"/>
								</td>
								<td align="right">
									<xsl:value-of select="format-number(@Amount,'###,##0')"/>
								</td>
							</tr>
						</xsl:for-each>
						<TR>
							<TD colspan="7"></TD>
						</TR>
					</TABLE>
				</div>
			</xsl:if>
		</xsl:for-each>

		<xsl:if test="count(//detail) = 0">
			<div class="table-responsive">
				<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hover-table">
					<THEAD>
						<TR>
							<TH>Player</TH>
							<TH>Placed</TH>
							<TH>PaymentMethod</TH>
							<TH>Reference</TH>
							<TH>Description</TH>
							<TH>Amount</TH>
						</TR>
					</THEAD>
					<TR CLASS="TrGameBottom">
						<TD colspan="6"></TD>
					</TR>
				</TABLE>
			</div>
		</xsl:if>

	</xsl:template>

	<xsl:template match="ZNAME" name="convertcommas">
		<xsl:param name="text" select="."/>
		<xsl:value-of select="substring-before(concat($text,','),',')" />
		<xsl:if test="contains($text,',')">
			<br />
			<xsl:call-template name="convertcommas">
				<xsl:with-param name="text" select="substring-after($text,',')" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
