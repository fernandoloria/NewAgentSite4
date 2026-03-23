<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">

		<div class="row page-titles">
			<div class="col-md-12 col-12 align-self-center">
				<h3 class="main-title m-b-0 m-t-0">Top Players</h3>
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
									<label for="cIdSport">Sport:</label>
									<br></br>
									<SELECT class="form-control form-control-sm" NAME="cIdSport">
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
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="Date2">Order by:</label>
									<br></br>
									<input type="radio" name="rOrderBy" id="rOrderBy" value="true">
										<xsl:if test="//@OrderByWinner = 'True'">
											<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
										</xsl:if>
										Top Winner
									</input>
									<input type="radio" name="rOrderBy" id="rOrderBy" value="false">
										<xsl:if test="//@OrderByWinner = 'False'">
											<xsl:attribute name="CHECKED">CHECKED</xsl:attribute>
										</xsl:if>
										Top Losser
									</input>
								</div>
							</div>
						</div>
						<div class="row">
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">
									<label for="TopNumber">Number of Players:</label>
									<br></br>
									<INPUT TYPE="text" class="form-control form-control-sm" name="TopNumber" id="TopNumber" value="{@TopNumber}" />
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
							<div class="col-xs-12 col-sm-12 col-md-3 col-lg-3">
								<div class="form-group">

								</div>
							</div>
						</div>

						<h4 class="card-title">
							<xsl:value-of select="//@StartDate" /> To
							<xsl:value-of select="//@EndDate" />
						</h4>
					</div>
				</div>
			</div>
		</div>
		<div class="table-responsive">
			<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm">
				<THEAD>
					<TR>
						<TH>Player</TH>
						<xsl:if test="//@IsDistributor = 'True'">
							<TH>Agent</TH>
						</xsl:if>
						<TH>Last Wager</TH>
						<TH>Win</TH>
						<TH>Lose</TH>
						<TH>Net</TH>
						<TH>Net%</TH>
						<th class="d-none d-lg-table-cell">Balance</th>
						<th class="d-table-cell d-md-none">Bal</th>
					</TR>
				</THEAD>
				<xsl:for-each select="player">
					<TR>
						<TD>
							<xsl:value-of select="@Player" />
						</TD>
						<xsl:if test="//@IsDistributor = 'True'">
							<TD>
								<xsl:value-of select="@Agent" />
							</TD>
						</xsl:if>
						<TD>
							<xsl:value-of select="@LastWager" />
						</TD>
						<TD>
							<xsl:value-of select="format-number(@Win,'###,##0')" />
						</TD>
						<TD>
							<xsl:value-of select="format-number(@Lose,'###,##0')" />
						</TD>
						<TD>
							<xsl:value-of select="format-number(@Net,'###,##0')" />
						</TD>
						<TD>
							<xsl:choose>
								<xsl:when test="number(@Win - @Lose) != 0 and string(@Net) != ''">
									<xsl:value-of select="format-number((@Net div (@Win - @Lose)) * 100, '###,##0.00')" />
								</xsl:when>
								<xsl:otherwise>0.00</xsl:otherwise>
							</xsl:choose>

						</TD>
						<TD>
							<xsl:value-of select="format-number(@CurrentBalance,'###,##0')" />
						</TD>
					</TR>
				</xsl:for-each>
				<TR>
					<TD>Totals</TD>
					<xsl:if test="//@IsDistributor = 'True'">
						<TD colspan="2">
							Players:
							<xsl:value-of select="count(player/@Player)" />
						</TD>
					</xsl:if>
					<xsl:if test="//@IsDistributor = 'False'">
						<TD>
							Players:
							<xsl:value-of select="count(player/@Player)" />
						</TD>
					</xsl:if>
					<TD>
						Win:
						<xsl:value-of select="format-number(sum(player/@Win),'###,##0')" />
					</TD>
					<TD>
						Lose:
						<xsl:value-of select="format-number(sum(player/@Lose),'###,##0')" />
					</TD>
					<TD>
						Net:
						<xsl:value-of select="format-number(sum(player/@Net),'###,##0')" />
					</TD>
					<TD></TD>
				</TR>
			</TABLE>
		</div>

	</xsl:template>

</xsl:stylesheet>
