<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8"/>

	<xsl:template match="//xml">

		<div class="row">
			<div class="page-titles">
				<h4>Agent Adjustment</h4>
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
									<br/>
									<input type="text" class="form-control form-control-sm datepicker" name="Date1" value="{@StartDate}"/>
								</div>
							</div>

							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date2">End Date:</label>
									<br/>
									<input type="text" class="form-control form-control-sm datepicker" name="Date2" value="{@EndDate}"/>
								</div>
							</div>

							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="cCurrency">Currency:</label>
									<br/>
									<select class="form-control form-control-sm" name="cCurrency" onchange="post();">
										<xsl:for-each select="currency">
											<option value="{@IdCurrency}">
												<xsl:if test="@AgentCurrency='True'">
													<xsl:attribute name="selected">selected</xsl:attribute>
												</xsl:if>
												<xsl:value-of select="@Currency"/> (<xsl:value-of select="@Symbol"/>)
											</option>
										</xsl:for-each>
									</select>
								</div>
							</div>

							<div class="col-xs-12 col-sm-12 col-md-2 col-lg-2">
								<div class="form-group">
									<input type="submit" class="btn btn-primary" style="margin-top:28px;" value="Submit" name="Submit"/>
								</div>
							</div>

						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="col-lg-12">
			<div class="card">
				<div class="card-body">
					<center>
						<h4 class="card-title">
							<xsl:value-of select="@StartDate"/> To
							<xsl:value-of select="@EndDate"/>
						</h4>
					</center>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">

						<xsl:for-each select="Agent">
							<div class="table-responsive">
								<table class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hover-table">
									<thead>
										<tr class="trAgent">
											<th colspan="7">
												<xsl:value-of select="@Agent" disable-output-escaping="yes"/>
											</th>
										</tr>
										<tr class="GameHeader">
											<th>Date</th>
											<th>Ref.</th>
											<th>Type</th>
											<th>Description</th>
											<th>User</th>
											<th>Placed Date</th>
											<th>Amount</th>
										</tr>
									</thead>
									<xsl:for-each select="Adjustment">
										<tr>
											<td>
												<xsl:value-of select="@Date"/>
											</td>
											<td>
												<xsl:value-of select="@Reference"/>
											</td>
											<td>
												<xsl:value-of select="@TransactionType"/>
											</td>
											<td>
												<xsl:value-of select="@Description"/>
											</td>
											<td>
												<xsl:value-of select="@User"/>
											</td>
											<td>
												<xsl:value-of select="@PlacedDate"/>
											</td>
											<td>
												<xsl:value-of select="format-number(@Amount,'###,##0')"/>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</div>

							<br/>

							<xsl:for-each select="Player">
								<div class="table-responsive">
									<table class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm hover-table">
										<thead>
											<tr class="trAgent">
												<th colspan="7">
													Player <xsl:value-of select="@Player"/> Adjustments
												</th>
											</tr>
											<tr class="GameHeader">
												<th>Date</th>
												<th>Reference</th>
												<th class="d-md-none">Description</th>
												<th class="d-none d-lg-table-cell">Type</th>
												<th class="d-none d-lg-table-cell">Description</th>
												<th class="d-none d-lg-table-cell">User</th>
												<th class="d-none d-lg-table-cell">Placed Date</th>
												<th>Amount</th>
											</tr>
										</thead>
										<xsl:for-each select="Adjustment">
											<tr>
												<td>
													<xsl:value-of select="@Date"/>
												</td>
												<td>
													<xsl:value-of select="@Reference"/>
												</td>
												<td class="d-md-none">
													<xsl:value-of select="@TransactionType"/><br/>
													<xsl:value-of select="@Description"/><br/>
													<xsl:value-of select="@User"/><br/>
												</td>
												<td class="d-none d-lg-table-cell">
													<xsl:value-of select="@TransactionType"/>
												</td>
												<td class="d-none d-lg-table-cell">
													<xsl:value-of select="@Description"/>
												</td>
												<td class="d-none d-lg-table-cell">
													<xsl:value-of select="@User"/>
												</td>
												<td class="d-none d-lg-table-cell">
													<xsl:value-of select="@PlacedDate"/>
												</td>
												<td>
													<xsl:value-of select="format-number(@Amount,'###,##0')"/>
												</td>
											</tr>
										</xsl:for-each>
									</table>
								</div>
							</xsl:for-each>
							<div class="row">
								<div class="page-titles">
									<h4>
										Total Adjustment of <xsl:value-of select="@Agent" disable-output-escaping="yes"/>:
										<xsl:value-of select="format-number(sum(Adjustment/@Amount) + sum(Player/Adjustment/@Amount),'###,##0')"/>
									</h4>
								</div>
							</div>
						</xsl:for-each>

					</div>
				</div>
			</div>
		</div>

	</xsl:template>
</xsl:stylesheet>
