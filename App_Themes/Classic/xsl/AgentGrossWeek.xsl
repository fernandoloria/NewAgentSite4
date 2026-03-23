<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">



		<div class="row">
			<div class="page-titles">
				<h4>Agent Gross Week</h4>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date1">Date Week:</label>
									<br></br>
									<INPUT TYPE="text" class="form-control form-control-sm datepicker" NAME="Date1" value="{@StartDate}" />
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
								<div class="form-group">
									<INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit" />
								</div>
							</div>
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">

								</div>
							</div>
						</div>

						<h4 class="card-title">
							<xsl:value-of select="@StartDate" /> To
							<xsl:value-of select="@EndDate" />
						</h4>
					</div>
				</div>
			</div>
		</div>

		<xsl:if test="count(//Player) != 0">
			<xsl:for-each select="Agent">
				<div class="table-responsive">
					<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm" >
						<thead>
							<tr class="trAgent">
								<th colspan="8">
									Agent
									<xsl:value-of select="@Agent" disable-output-escaping="yes" />
								</th>
							</tr>
							<tr class="GameHeader">
								<th>Player</th>
								<th>Fwd</th>
								<th>Pmts</th>
								<th>Casino Week</th>
								<th>Sports Week</th>
								<th>Horses Week</th>
								<th>Total Week</th>
								<th>Total</th>
							</tr>
						</thead>
						<xsl:for-each select="Player">
							<tr>
								<td style="word-wrap: unset !important;">
									<xsl:value-of select="@Player" disable-output-escaping="yes" />
									<br/>
									(<xsl:value-of select="@Name" disable-output-escaping="yes" />)

								</td>
								<td>
									<xsl:value-of select="format-number(@BalFwd,'###,##0.##')" disable-output-escaping="yes" />
								</td>
								<td>
									<xsl:value-of select="format-number(@Pmts,'###,##0.##')" disable-output-escaping="yes" />
								</td>
								<td>
									<xsl:value-of select="format-number(@CasinoWeek,'###,##0.##')" disable-output-escaping="yes" />
								</td>
								<td>
									<xsl:value-of select="format-number(@SportsWeek,'###,##0.##')" disable-output-escaping="yes" />
								</td>
								<td>
									<xsl:value-of select="format-number(@HorsesWeek,'###,##0.##')" disable-output-escaping="yes" />
								</td>
								<td>
									<xsl:value-of select="format-number(number(@CasinoWeek + @SportsWeek + @HorsesWeek),'###,##0.##')" disable-output-escaping="yes" />
								</td>
								<td>
									<xsl:value-of select="format-number(number(@CasinoWeek + @SportsWeek + @HorsesWeek + @BalFwd + @Pmts),'###,##0.##')" disable-output-escaping="yes" />
								</td>
							</tr>
						</xsl:for-each>
						<tr>
							<td>
								<xsl:value-of select="count(Player/@Player)" /> Players
							</td>
							<td>
								<xsl:value-of select="format-number(sum(Player/@BalFwd),'###,##0.##')" disable-output-escaping="yes" />
							</td>
							<td>
								<xsl:value-of select="format-number(sum(Player/@Pmts),'###,##0.##')" disable-output-escaping="yes" />
							</td>
							<td>
								<xsl:value-of select="format-number(sum(Player/@CasinoWeek),'###,##0.##')" disable-output-escaping="yes" />
							</td>
							<td>
								<xsl:value-of select="format-number(sum(Player/@SportsWeek),'###,##0.##')" disable-output-escaping="yes" />
							</td>
							<td>
								<xsl:value-of select="format-number(sum(Player/@HorsesWeek),'###,##0.##')" disable-output-escaping="yes" />
							</td>
							<td>
								<xsl:value-of select="format-number(number(sum(Player/@CasinoWeek) + sum(Player/@SportsWeek) + sum(Player/@HorsesWeek)),'###,##0.##')" disable-output-escaping="yes" />
							</td>
							<td>
								<xsl:value-of select="format-number(number(sum(Player/@CasinoWeek) + sum(Player/@SportsWeek) + sum(Player/@HorsesWeek) + sum(Player/@BalFwd) + sum(Player/@Pmts)),'###,##0.##')" disable-output-escaping="yes" />
							</td>
						</tr>
					</TABLE>
				</div>
			</xsl:for-each>
			<div class="table-responsive">
				<TABLE class="table color-table success-table table-bordered table-striped table-sm hover-table">
					<thead>
						<tr>
							<th colspan="9">Totals</th>
						</tr>
						<tr>
							<th colspan="2">
								<xsl:value-of select="count(//Player/@Player)" /> Players
							</th>
							<th>BalFwd</th>
							<th>Pmts</th>
							<th>Casino Week</th>
							<th>Sports Week</th>
							<th>Horses Week</th>
							<th>Total Week</th>
							<th>Total</th>
						</tr>
					</thead>
					<tr>
						<td colspan="2">
						</td>
						<td>
							<xsl:value-of select="format-number(sum(//Player/@BalFwd),'###,##0.##')" disable-output-escaping="yes" />
						</td>
						<td>
							<xsl:value-of select="format-number(sum(//Player/@Pmts),'###,##0.##')" disable-output-escaping="yes" />
						</td>
						<td>
							<xsl:value-of select="format-number(sum(//Player/@CasinoWeek),'###,##0.##')" disable-output-escaping="yes" />
						</td>
						<td>
							<xsl:value-of select="format-number(sum(//Player/@SportsWeek),'###,##0.##')" disable-output-escaping="yes" />
						</td>
						<td>
							<xsl:value-of select="format-number(sum(//Player/@HorsesWeek),'###,##0.##')" disable-output-escaping="yes" />
						</td>
						<td>
							<xsl:value-of select="format-number(number(sum(//Player/@CasinoWeek) + sum(//Player/@SportsWeek) + sum(//Player/@HorsesWeek)),'###,##0.##')" disable-output-escaping="yes" />
						</td>
						<td>
							<xsl:value-of select="format-number(number(sum(//Player/@CasinoWeek) + sum(//Player/@SportsWeek) + sum(//Player/@HorsesWeek) + sum(//Player/@BalFwd) + sum(//Player/@Pmts)),'###,##0.##')" disable-output-escaping="yes" />
						</td>
					</tr>
				</TABLE>
			</div>
		</xsl:if>

		<xsl:if test="count(//Player) = 0">
			<div class="table-responsive">
				<TABLE class="table color-table success-table table-bordered table-striped table-sm">
					<tr>
						<td>No data.</td>
					</tr>
				</TABLE>
			</div>
		</xsl:if>

	</xsl:template>

</xsl:stylesheet>
