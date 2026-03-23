<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output  method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">
		<div class="row page-titles">
			<div class="col-md-12 col-12 align-self-center">
				<h3 class="main-title m-b-0 m-t-0">Changed Wager</h3>
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
									<INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{//xml/@StartDate}" />
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date2">Final Date:</label>
									<br></br>
									<INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date2" value="{//xml/@EndDate}" />
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
								<INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:24px;" value="Submit" name="Submit" />
							</div>
						</div>
						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date2">Changed Type:</label>
									<br></br>
									<SELECT class="form-control form-control-sm"  NAME="cType" OnChange="post();">
										<xsl:for-each select="type">
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
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
								</div>
							</div>
						</div>
						<H4 class="text-center">
							<xsl:value-of select="//xml/@StartDate"/> to <xsl:value-of select="//xml/@EndDate"/>
						</H4>
					</div>
				</div>
			</div>
		</div>
		<div class="table-responsive">
			<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
				<xsl:for-each select="agent">
					<THEAD>
						<tr class="trAgent">
							<th colspan="10">
								<xsl:value-of select="@Agent" />
							</th>
						</tr>

					</THEAD>
					<xsl:for-each select="detail">
						<THEAD>
							<TR>
								<TH colspan="5">
									<B>
										<xsl:value-of select="@Player" />
									</B>
									<br/>
									<B>Place Date </B>
									<xsl:value-of select="@PlacedDate" />
								</TH>
							</TR>
							<TR>
								<TH class="wagerDescription"></TH>
								<TH>
									Ticket # <xsl:value-of select="@ticketNumber" />
								</TH>
								<TH>Risk</TH>
								<TH>Win </TH>
								<TH>User</TH>
							</TR>
						</THEAD>
						<TR>
							<TD>
								<B>
									Original Wager <xsl:value-of select="@TicketNumber" />
								</B>
							</TD>
							<TD>
								<B>

									<xsl:value-of select="@LastModifChanged" />
								</B>
								<BR />
								<xsl:value-of disable-output-escaping="yes" select="@Description" />
							</TD>
							<TD>
								<xsl:value-of select="@Risk" />
							</TD>
							<TD>
								<xsl:value-of select="@Win" />
							</TD>
							<TD>
								<B>By</B>
								<BR />
								<xsl:value-of select="@Phone" />
								<BR />
								<B>
									<xsl:value-of select="@LoginChanged" />
								</B>
								<BR />
								<xsl:value-of select="@Login" />
							</TD>
						</TR>
						<TR>
							<TD>
								<B class="neg">
									Changed Wager
								</B>
							</TD>
							<TD>
								<B>
									<xsl:value-of select="@NewPlacedDate" />
								</B>
								<BR />
								<xsl:value-of disable-output-escaping="yes" select="@NewDescription" />
							</TD>
							<TD>
								<xsl:value-of select="@NewRisk" />
							</TD>
							<TD>
								<xsl:value-of select="@NewWin" />
							</TD>
							<TD>
								Operation
								<br/>
								<xsl:value-of select="@Operation" />
							</TD>
						</TR>
					</xsl:for-each>
					<TR CLASS="TrGameBottom">
						<TD colspan="10"></TD>
					</TR>
				</xsl:for-each>
			</TABLE>
		</div>

	</xsl:template>

</xsl:stylesheet>
