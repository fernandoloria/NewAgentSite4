<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output  method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">
		<SCRIPT LANGUAGE="JavaScript">
			function post(){
			document.forms[0].action = 'ActionByPlayer.aspx';
			document.forms[0].submit();
			}
		</SCRIPT>

		<div class="row page-titles">
			<div class="col-md-12 col-12 align-self-center">
				<h3 class="main-title m-b-0 m-t-0">Action by Player</h3>
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
									<SELECT class="form-control form-control-sm tomlist"  NAME="cCurrency" OnChange="post();">
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
									<INPUT type="SUBMIT" class="btn btn-primary" style="margin-top:24px;" value="Submit" name="Submit" />
								</div>
							</div>
						</div>
						<h4 class="card-title">
							From <xsl:value-of select="@StartDate"/> To  <xsl:value-of select="@EndDate"/>
						</h4>

					</div>
				</div>
			</div>
		</div>
		<xsl:for-each select="agent">
			<div class="table-responsive">
				<TABLE class="tblWeeklyBalance table color-table success-table table-bordered table-striped table-sm table-hover ">
					<THEAD>
						<tr class="trAgent">
							<th colspan="8">
								Agent
								<xsl:value-of select="@Agent" disable-output-escaping="yes" />
							</th>
						</tr>
						<TR class="GameHeader">
							<TH>Player</TH>
							<TH colspan="2" style="text-aling:center;">Sports</TH>
							<TH colspan="2" style="text-aling:center;">Other</TH>
							<TH colspan="2" style="text-aling:center;">Adjustment</TH>
							<TH>Total</TH>
						</TR>
					</THEAD>
					<xsl:for-each select="player">

						<TR>
							<TD>
								<xsl:value-of disable-output-escaping="yes" select="@Player"/>
								<br/>
								<span>
									/<xsl:value-of disable-output-escaping="yes" select="@Password"/>
								</span>
							</TD>
							<TD>
								Straight<br/>
								Parlay<br/>
								Teaser<br/>
								Reverse<br/>
							</TD>
							<TD>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@StraightBet,'###,##0')"/>
								<br/>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@Parlay,'###,##0')"/>
								<br/>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@Teaser,'###,##0')"/>
								<br/>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@Reverse,'###,##0')"/>
							</TD>
							<TD>
								Casino<br/>
								Horses<br/>
								Other<br/>
							</TD>
							<TD>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@Casino,'###,##0')"/>
								<br/>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@Horses,'###,##0')"/>
								<br/>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@OtherWagers,'###,##0')"/>
							</TD>
							<TD>
								Other<br/>
								Horses<br/>
							</TD>
							<TD>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@OtherAdjustment,'###,##0')"/>
								<br/>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@HorseAdjustment,'###,##0')"/>
							</TD>
							<TD>
								<xsl:value-of disable-output-escaping="yes" select="format-number(@Total,'###,##0')"/>
							</TD>
							<!--
					<xsl:for-each select="@*">
						<xsl:if test="name()!='Agent'">
							<TD> <xsl:value-of disable-output-escaping="yes" select="."/></TD>
						</xsl:if>
					</xsl:for-each>	-->
						</TR>
					</xsl:for-each>
					<xsl:call-template name="totals">
						<xsl:with-param name="agent" select="@Agent"/>
					</xsl:call-template>
				</TABLE>
			</div>
		</xsl:for-each>

		<xsl:if test="count(//agent) > 1">
			<xsl:call-template name="MasterTotal"/>
		</xsl:if>

		<xsl:if test="count(//agent) = 0">
			<div class="table-responsive">
				<TABLE class="table color-table success-table table-bordered table-striped table-sm">
					<TR>
						<TD colspan="8">Agent </TD>
					</TR>
					<TR>
						<TD>Player</TD>
						<TD colspan="2">Sports</TD>
						<TD colspan="2">Other</TD>
						<TD colspan="2">Adjustment</TD>
						<TD>Total</TD>
					</TR>
					<TR CLASS="TrGameBottom">
						<TD COLSPAN="8"> No data for this Range of dates.</TD>
					</TR>
				</TABLE>
			</div>
		</xsl:if>


	</xsl:template>


	<xsl:template name="totals">
		<xsl:param name="agent" />

		<TR>
			<TD>Total</TD>
			<TD>
				Straight<br/>
				Parlay<br/>
				Teaser<br/>
				Reverse<br/>
			</TD>
			<TD>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@StraightBet),'###,##0')" />
				<br/>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@Parlay),'###,##0')" />
				<br/>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@Teaser),'###,##0')" />
				<br/>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@Reverse),'###,##0')" />
			</TD>
			<TD>
				Casino<br/>
				Horses<br/>
				Other<br/>
			</TD>
			<TD>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@Casino),'###,##0')" />
				<br/>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@Horses),'###,##0')" />
				<br/>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@OtherWagers),'###,##0')" />
			</TD>
			<TD>
				Other<br/>
				Horses<br/>
			</TD>
			<TD>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@OtherAdjustment),'###,##0')" />
				<br/>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@HorseAdjustment),'###,##0')" />
			</TD>
			<TD>
				<xsl:value-of select="format-number(sum(//player[../@Agent=$agent]/@Total),'###,##0')" />
			</TD>
		</TR>
		<TR>
			<TD CLASS="TrGameBottom" COLSPAN="8" align="center">
				<xsl:value-of select="count(//player[../@Agent=$agent])" /> Total Players
			</TD>
		</TR>

	</xsl:template>

	<xsl:template name="MasterTotal">
		<div class="table-responsive">
			<TABLE class="table color-table success-table table-bordered table-striped table-sm">
				<THEAD>
					<TR>
						<TH>Master</TH>
						<TH colspan="2">Sports</TH>
						<TH>Casino</TH>
						<TH>Horses</TH>
						<TH>Other Wagers</TH>
						<TH>Adjustment</TH>
						<TH>Horse Adjustment</TH>
						<TH>Total</TH>
					</TR>
				</THEAD>
				<TR>
					<TD>Total</TD>
					<TD>
						Straight<br/>
						Parlay<br/>
						Teaser<br/>
						Reverse<br/>
					</TD>
					<TD>
						<xsl:value-of select="format-number(sum(//player/@StraightBet),'###,##0')" />
						<br/>
						<xsl:value-of select="format-number(sum(//player/@Parlay),'###,##0')" />
						<br/>
						<xsl:value-of select="format-number(sum(//player/@Teaser),'###,##0')" />
						<br/>
						<xsl:value-of select="format-number(sum(//player/@Reverse),'###,##0')" />
					</TD>
					<TD>
						Casino<br/>
						Horses<br/>
						Other<br/>
					</TD>
					<TD>
						<xsl:value-of select="format-number(sum(//player/@Casino),'###,##0')" />
						<xsl:value-of select="format-number(sum(player/@Horses),'###,##0')" />
						<xsl:value-of select="format-number(sum(//player/@OtherWagers),'###,##0')" />
					</TD>
					<TD>
						Other<br/>
						Horses<br/>
					</TD>
					<TD>
						<xsl:value-of select="format-number(sum(//player/@OtherAdjustment),'###,##0')" />
						<xsl:value-of select="format-number(sum(//player/@HorseAdjustment),'###,##0')" />
					</TD>
					<TD>
						<xsl:value-of select="format-number(sum(//player/@Total),'###,##0')" />
					</TD>
				</TR>
				<TR>
					<TD CLASS="TrGameBottom" COLSPAN="8" align="center">
						<xsl:value-of select="count(//player)" /> Total Players
					</TD>
				</TR>
			</TABLE>
		</div>
	</xsl:template>

</xsl:stylesheet>
