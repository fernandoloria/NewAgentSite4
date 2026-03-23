<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">
		<div class="row page-titles">
			<div class="col-12 align-self-center">
				<h3 class="main-title m-b-0 m-t-0">Agent Wager Listing</h3>
			</div>
		</div>

		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">

						<!-- Filters row -->
						<div class="row g-3">
							<div class="col-12 col-md-3">
								<div class="form-group">
									<label for="Date1">Initial Date:</label>
									<input type="text" class="form-control form-control-sm datepicker" name="Date1" value="{@StartDate}" />
								</div>
							</div>
							<div class="col-12 col-md-3">
								<div class="form-group">
									<label for="Date2">End Date:</label>
									<input type="text" class="form-control form-control-sm datepicker" name="Date2" value="{@EndDate}" />
								</div>
							</div>
							<div class="col-12 col-md-3">
								<div class="form-group">
									<label for="cCurrency">Currency:</label>
									<select class="form-control form-control-sm" name="cCurrency" onChange="post();">
										<xsl:for-each select="currency">
											<option value="{@IdCurrency}">
												<xsl:if test="@AgentCurrency='True'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@Currency" /> (<xsl:value-of select="@Symbol" />)
											</option>
										</xsl:for-each>
									</select>
								</div>
							</div>
							<div class="col-12 col-md-3">
								<div class="form-group">
									<label class="form-label invisible">Submit</label>
									<input type="submit" class="btn btn-primary w-100" value="Submit" name="Submit" />
								</div>
							</div>
						</div>

						<div class="row g-3">
							<div class="col-12 col-md-3">
								<div class="form-group">
									<label for="cPlayer">History for Player:</label>
									<select class="form-control form-control-sm" name="cPlayer" onChange="post();">
										<xsl:for-each select="combobox">
											<option value="{@Value}">
												<xsl:if test="@Selected='1'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@Text" />
											</option>
										</xsl:for-each>
									</select>
								</div>
							</div>
							<div class="col-12 col-md-3"></div>
							<div class="col-12 col-md-3"></div>
						</div>

						<h4 class="card-title">
							<xsl:value-of select="@StartDate" /> To <xsl:value-of select="@EndDate" />
						</h4>

					</div>
				</div>
			</div>
		</div>

		<xsl:choose>
			<xsl:when test="count(Agent) != 0">
				<xsl:for-each select="Agent">
					<div class="table-responsive">
						<table class="table color-table success-table table-bordered table-striped table-sm">

							<tr class="trAgent">
								<td colspan="8" class="table-title">
									Agent <xsl:value-of select="@Agent" disable-output-escaping="yes" />
								</td>
							</tr>

							<xsl:for-each select="Player">
								<tr class="trAgent">
									<td colspan="8" class="AgentTitle">
										<xsl:value-of select="@Player" disable-output-escaping="yes" />
									</td>
								</tr>

								<tr class="page-titles">
									<th class="d-none d-md-table-cell">Ticket</th>
									<th class="d-none d-md-table-cell">Placed</th>
									<th>Description</th>
									<th>Risk</th>
									<th>Win</th>
									<th>Result</th>
									<th class="d-none d-md-table-cell">User/Score</th>
									<th>Phone/IP</th>
								</tr>

								<xsl:for-each select="Wager">
									<tr>
										<td class="d-none d-md-table-cell">
											<xsl:value-of select="@Ticket" disable-output-escaping="yes" />
										</td>
										<td class="d-none d-md-table-cell">
											<xsl:value-of select="@PlacedDate" disable-output-escaping="yes" />
										</td>
										<td>
											<xsl:value-of select="@Description" disable-output-escaping="yes" />
										</td>
										<td>
											<xsl:value-of select="format-number(@RiskAmount,'###,##0')" disable-output-escaping="yes" />
										</td>
										<td>
											<xsl:value-of select="format-number(@WinAmount,'###,##0')" disable-output-escaping="yes" />
										</td>
										<td>
											<xsl:value-of select="@Result" disable-output-escaping="yes" />
										</td>
										<td class="d-none d-md-table-cell">
											<xsl:value-of select="@User" disable-output-escaping="yes" />
										</td>
										<td>
											<xsl:call-template name="convertcommas">
												<xsl:with-param name="text" select="@PhoneLine"/>
											</xsl:call-template>
										</td>
									</tr>

									<!-- child wagers -->
									<xsl:for-each select="Wager">
										<tr>
											<td class="d-none d-lg-table-cell"></td>
											<td>
												<xsl:value-of select="@IdSport" disable-output-escaping="yes" />
											</td>
											<td class="d-none d-lg-table-cell">
												<xsl:value-of select="@Description" disable-output-escaping="yes" />
											</td>
											<td colspan="2" class="d-md-none">
												<xsl:value-of select="@Description" disable-output-escaping="yes" />
											</td>
											<td class="d-none d-lg-table-cell"></td>
											<td class="d-none d-lg-table-cell"></td>
											<td>
												<xsl:value-of select="@Result" disable-output-escaping="yes" />
											</td>
											<td>
												<xsl:if test="@VisitorScore != ''">
													<xsl:value-of select="@VisitorScore" disable-output-escaping="yes" /> -
													<xsl:value-of select="@HomeScore" disable-output-escaping="yes" />
												</xsl:if>
											</td>
											<td class="d-none d-lg-table-cell"></td>
										</tr>
									</xsl:for-each>
									<!-- /child wagers -->

								</xsl:for-each>
							</xsl:for-each>
						</table>
					</div>

					<div class="table-responsive">
						<table class="table color-table success-table table-bordered table-striped table-sm hover-table">
							<tr class="page-titles">
								<td>
									Totals (Win-Lose):
									<xsl:value-of select="format-number(number(sum(Player/Wager[@Result = 'WIN']/@WinAmount) - sum(Player/Wager[@Result = 'LOSE']/@RiskAmount)),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td>
									Total Risk:
									<xsl:value-of select="format-number(sum(Player/Wager/@RiskAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td class="text-end">
									Total To Win:
									<xsl:value-of select="format-number(sum(Player/Wager/@WinAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td class="text-end">
									Total Win:
									<xsl:value-of select="format-number(sum(Player/Wager[@Result = 'WIN']/@WinAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td class="text-end">
									Total Lose:
									<xsl:value-of select="format-number(sum(Player/Wager[@Result = 'LOSE']/@RiskAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
							</tr>
						</table>
					</div>
				</xsl:for-each>

				<xsl:if test="count(Agent) &gt; 1">
					<div class="table-responsive">
						<table class="table color-table success-table table-bordered table-striped table-sm hover-table">
							<tr class="AgentTitle">
								<td colspan="5">Master Agent Totals</td>
							</tr>
							<tr class="TbInTitle">
								<td>
									Totals (Win-Lose):
									<xsl:value-of select="format-number(number(sum(Agent/Player/Wager[@Result = 'WIN']/@WinAmount) - sum(Agent/Player/Wager[@Result = 'LOSE']/@RiskAmount)),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td>
									Total Risk:
									<xsl:value-of select="format-number(sum(Agent/Player/Wager/@RiskAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td class="text-end">
									Total To Win:
									<xsl:value-of select="format-number(sum(Agent/Player/Wager/@WinAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td class="text-end">
									Total Win:
									<xsl:value-of select="format-number(sum(Agent/Player/Wager[@Result = 'WIN']/@WinAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
								<td class="text-end">
									Total Lose:
									<xsl:value-of select="format-number(sum(Agent/Player/Wager[@Result = 'LOSE']/@RiskAmount),'###,##0')" disable-output-escaping="yes" />
								</td>
							</tr>
						</table>
					</div>
				</xsl:if>
			</xsl:when>

			<xsl:otherwise>
				<div class="table-responsive">
					<table class="table color-table success-table table-bordered table-striped table-sm">
						<tr class="TbInTitle">
							<td>No data.</td>
						</tr>
					</table>
				</div>
			</xsl:otherwise>
		</xsl:choose>


	</xsl:template>

	<xsl:template match="ZNAME" name="convertcommas">
		<xsl:param name="text" select="."/>
		<a href="http://www.ip-tracker.org/locator/ip-lookup.php?ip={substring-before(concat($text,','),',')}" target="_blank">
			<xsl:value-of select="substring-before(concat($text,','),',')" />
		</a>
		<xsl:if test="contains($text,',')">
			<br />
			<a href="http://www.ip-tracker.org/locator/ip-lookup.php?ip={substring-after($text,',')}" target="_blank">
				<xsl:call-template name="convertcommas">
					<xsl:with-param name="text" select="substring-after($text,',')" />
				</xsl:call-template>
			</a>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
