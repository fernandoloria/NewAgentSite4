<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" indent="no" encoding="UTF-8" />

	<xsl:template match="//xml">

		<SCRIPT LANGUAGE="JavaScript" TYPE="text/JavaScript">
			function post() {
			document.forms[0].submit();
			}

			function showWagerType()
			{
			$('.straights').removeClass('d-none d-lg-table-cell');
			$('.parlays').removeClass('d-none d-lg-table-cell');
			$('.teasers').removeClass('d-none d-lg-table-cell');
			$('.reverses').removeClass('d-none d-lg-table-cell');

			if($('select[name=wagerType]').val() != 'S')
			{
			$('.straights').addClass('d-none d-lg-table-cell');
			}
			if($('select[name=wagerType]').val() != 'P')
			{
			$('.parlays').addClass('d-none d-lg-table-cell');
			}
			if($('select[name=wagerType]').val() != 'T')
			{
			$('.teasers').addClass('d-none d-lg-table-cell');
			}
			if($('select[name=wagerType]').val() != 'R')
			{
			$('.reverses').addClass('d-none d-lg-table-cell');
			}
			}


		</SCRIPT>

		<div class="row">
			<div class="page-titles">
				<h4>Agent Exposure</h4>
			</div>
		</div>

		<div class="row">
			<div class="col-lg-12">
				<div class="card">
					<div class="card-body">
						<div class="row">
							<div class="col-md-3">
								<strong> Sports: </strong>
								<SELECT class="form-control form-control-sm" NAME="cSport" OnChange="post();">
									<xsl:for-each select="idsport">
										<OPTION VALUE="{@Value}">
											<xsl:if test="@Selected='1'">
												<xsl:attribute name="Selected">Selected</xsl:attribute>
											</xsl:if>
											<xsl:value-of select="@Text" />
										</OPTION>
									</xsl:for-each>
								</SELECT>
							</div>
							<div class="col-md-3">
								<strong> Currency: </strong>
								<SELECT class="form-control form-control-sm" NAME="cCurrency" id="cCurrency" OnChange="post();">
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
							<div class="col-md-3 d-lg-none">
								<strong> Wager Type: </strong>
								<SELECT class="form-control form-control-sm" NAME="wagerType" id="wagerType" OnChange="showWagerType();">
									<option value="S" selected="">Straights</option>
									<option value="P">Parlays</option>
									<option value="T">Teasers</option>
									<option value="R">Reverses</option>
								</SELECT>
							</div>
							<div class="col-md-3"> </div>
						</div>
						<div class="row">
							<div class="col-lg-12">
								<br></br>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="table-responsive">
			<TABLE CLASS="table color-table success-table table-bordered table-striped table-sm">
				<TR CLASS="table-title">
					<TD CLASS="GameHeaderChartTD">#</TD>
					<TD CLASS="GameHeaderChartTD">Teams</TD>
					<TD CLASS="GameHeaderChartTD straights" align="left" WIDTH="20%">
						<TABLE border="0" WIDTH="100%">
							<TR CLASS="trAgent">
								<TD colspan="3" align="center">Straights</TD>
							</TR>
							<TR CLASS="trAgent">
								<TD>Spread</TD>
								<TD>Total</TD>
								<TD>$Line</TD>
							</TR>
						</TABLE>
					</TD>
					<TD CLASS="GameHeaderChartTD parlays d-none d-lg-table-cell" align="left" WIDTH="20%">
						<TABLE border="0" WIDTH="100%">
							<TR CLASS="trAgent">
								<TD colspan="3" align="center">Parlays</TD>
							</TR>
							<TR CLASS="trAgent">
								<TD>Spread</TD>
								<TD>Total</TD>
								<TD>$Line</TD>
							</TR>
						</TABLE>
					</TD>
					<TD CLASS="GameHeaderChartTD teasers d-none d-lg-table-cell" align="left" WIDTH="20%">
						<TABLE border="0" WIDTH="100%">
							<TR CLASS="trAgent">
								<TD colspan="3" align="center">Teasers</TD>
							</TR>
							<TR CLASS="trAgent">
								<TD>Spread</TD>
								<TD>Total</TD>
								<TD>$Line</TD>
							</TR>
						</TABLE>
					</TD>
					<TD CLASS="GameHeaderChartTD reverses d-none d-lg-table-cell" align="left" WIDTH="20%">
						<TABLE border="0" WIDTH="100%">
							<TR CLASS="trAgent">
								<TD colspan="3" align="center">Reverses</TD>
							</TR>
							<TR CLASS="trAgent">
								<TD>Spread</TD>
								<TD>Total</TD>
								<TD>$Line</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<xsl:for-each select="detail">
					<TR>
						<xsl:if test="//xml/@SSport = 'TNT'">
							<TD>
								<xsl:value-of select="@VisitorNumber" />
							</TD>
							<TD>
								<xsl:value-of select="@VisitorTeam" />
							</TD>
							<TD class="straights">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_V0');">
													<xsl:value-of select="format-number(@StraightbetVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_V2');">
													<xsl:value-of select="format-number(@StraightbetVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_V4');">
													<xsl:value-of select="format-number(@StraightbetVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>
							</TD>
							<TD class="parlays d-none d-lg-table-cell">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_V0');">
													<xsl:value-of select="format-number(@ParlayVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_V2');">
													<xsl:value-of select="format-number(@ParlayVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_V4');">
													<xsl:value-of select="format-number(@ParlayVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>
							</TD>
							<TD class="teasers d-none d-lg-table-cell">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_V0');">
													<xsl:value-of select="format-number(@TeaserVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_V2');">
													<xsl:value-of select="format-number(@TeaserVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_V4');">
													<xsl:value-of select="format-number(@TeaserVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>
							</TD>
							<TD class="reverses d-none d-lg-table-cell">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_V0');">
													<xsl:value-of select="format-number(@ReversesVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_V2');">
													<xsl:value-of select="format-number(@ReversesVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_V4');">
													<xsl:value-of select="format-number(@ReversesVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>
							</TD>
						</xsl:if>

						<xsl:if test="//xml/@SSport != 'TNT'">
							<TD>
								<xsl:value-of select="@VisitorNumber" />
								<BR/>
								<xsl:value-of select="@HomeNumber" />
								<xsl:if test="//xml/@SSport = 'SOC'">
									<BR/>
									<xsl:value-of select="@HomeNumber + 1" />
								</xsl:if>
							</TD>
							<TD>
								<xsl:value-of select="@VisitorTeam" />
								<BR/>
								<xsl:value-of select="@HomeTeam" />
								<xsl:if test="//xml/@SSport = 'SOC'">
									<BR/>DRAW
								</xsl:if>
							</TD>
							<TD class="straights">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_V0');">
													<xsl:value-of select="format-number(@StraightbetVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_V2');">
													<xsl:value-of select="format-number(@StraightbetVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_V4');">
													<xsl:value-of select="format-number(@StraightbetVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetHSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_H1');">
													<xsl:value-of select="format-number(@StraightbetHSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetHTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_H3');">
													<xsl:value-of select="format-number(@StraightbetHTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@StraightbetHMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_H5');">
													<xsl:value-of select="format-number(@StraightbetHMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>

								<xsl:if test="//xml/@SSport = 'SOC' and @StraightbetD != '0'">
									<BR/>
									<A HREF="javascript:GetExposureDetail('{@IdGame}_SB_D');">
										<xsl:value-of select="format-number(@StraightbetD,'###,###')" />
									</A>
								</xsl:if>
							</TD>
							<TD class="parlays d-none d-lg-table-cell">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_V0');">
													<xsl:value-of select="format-number(@ParlayVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_V2');">
													<xsl:value-of select="format-number(@ParlayVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_V4');">
													<xsl:value-of select="format-number(@ParlayVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayHSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_H1');">
													<xsl:value-of select="format-number(@ParlayHSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayHTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_H3');">
													<xsl:value-of select="format-number(@ParlayHTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ParlayHMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_H5');">
													<xsl:value-of select="format-number(@ParlayHMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>

								<xsl:if test="//xml/@SSport = 'SOC' and @ParlayD != '0'">
									<BR/>
									<A HREF="javascript:GetExposureDetail('{@IdGame}_PB_D');">
										<xsl:value-of select="format-number(@ParlayD,'###,###')" />
									</A>
								</xsl:if>
							</TD>
							<TD class="teasers d-none d-lg-table-cell">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_V0');">
													<xsl:value-of select="format-number(@TeaserVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_V2');">
													<xsl:value-of select="format-number(@TeaserVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_V4');">
													<xsl:value-of select="format-number(@TeaserVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserHSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_H1');">
													<xsl:value-of select="format-number(@TeaserHSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserHTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_H3');">
													<xsl:value-of select="format-number(@TeaserHTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@TeaserHMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_H5');">
													<xsl:value-of select="format-number(@TeaserHMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>

								<xsl:if test="//xml/@SSport and @TeaserD != '0'">
									<BR/>
									<A HREF="javascript:GetExposureDetail('{@IdGame}_TB_D');">
										<xsl:value-of select="format-number(@TeaserD,'###,###')" />
									</A>
								</xsl:if>
							</TD>
							<TD class="reverses d-none d-lg-table-cell">
								<TABLE border="0" WIDTH="100%" HEIGHT="48">
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesVSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_V0');">
													<xsl:value-of select="format-number(@ReversesVSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesVTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_V2');">
													<xsl:value-of select="format-number(@ReversesVTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesVMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_V4');">
													<xsl:value-of select="format-number(@ReversesVMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
									<TR class="GameDetailChart">
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesHSpread != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_H1');">
													<xsl:value-of select="format-number(@ReversesHSpread,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesHTotal != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_H3');">
													<xsl:value-of select="format-number(@ReversesHTotal,'###,###')" />
												</A>
											</xsl:if>
										</TD>
										<TD WIDTH="33%" HEIGHT="24" ALIGN="center">
											<xsl:if test="@ReversesHMoney != '0'">
												<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_H5');">
													<xsl:value-of select="format-number(@ReversesHMoney,'###,###')" />
												</A>
											</xsl:if>
										</TD>
									</TR>
								</TABLE>

								<xsl:if test="//xml/@SSport = 'SOC' and @ReversesD != '0'">
									<BR/>
									<A HREF="javascript:GetExposureDetail('{@IdGame}_RB_D');">
										<xsl:value-of select="format-number(@ReversesD,'###,###')" />
									</A>
								</xsl:if>
							</TD>
						</xsl:if>
					</TR>
				</xsl:for-each>
				<xsl:if test="count(detail)>0">
					<TR CLASS="TrTotalOdd">
						<TD colspan="2" align="center">Totals</TD>
						<TD class="straights">
							<xsl:value-of select="format-number(sum(//detail/@StraightbetVSpread) + sum(//detail/@StraightbetHSpread) + sum(//detail/@StraightbetVTotal) + sum(//detail/@StraightbetHTotal) + sum(//detail/@StraightbetVMoney) + sum(//detail/@StraightbetHMoney) + sum(//detail/@StraightbetD),'###,###')" />
						</TD>
						<TD class="parlays d-none d-lg-table-cell">
							<xsl:value-of select="format-number(sum(//detail/@ParlayVSpread) + sum(//detail/@ParlayHSpread) + sum(//detail/@ParlayVTotal) + sum(//detail/@ParlayHTotal) + sum(//detail/@ParlayVMoney) + sum(//detail/@ParlayHMoney) + sum(//detail/@ParlayD),'###,###')" />
						</TD>
						<TD class="teasers d-none d-lg-table-cell">
							<xsl:value-of select="format-number(sum(//detail/@TeaserVSpread) + sum(//detail/@TeaserHSpread) + sum(//detail/@TeaserVTotal) + sum(//detail/@TeaserHTotal) + sum(//detail/@TeaserVMoney) + sum(//detail/@TeaserHMoney) + sum(//detail/@TeaserD),'###,###')" />
						</TD>
						<TD class="reverses d-none d-lg-table-cell">
							<xsl:value-of select="format-number(sum(//detail/@ReversesVSpread) + sum(//detail/@ReversesHSpread) + sum(//detail/@ReversesVTotal) + sum(//detail/@ReversesHTotal) + sum(//detail/@ReversesVMoney) + sum(//detail/@ReversesHMoney) + sum(//detail/@ReversesD),'###,###')" />
						</TD>
					</TR>
				</xsl:if>
				<xsl:if test="count(detail)=0">
					<TR CLASS="TrTotalOdd" align="center">
						<TD colspan="6">No Open bets for this Sport and WagerTypes are available.</TD>
					</TR>
				</xsl:if>
				<TR>
					<TD colspan="6"></TD>
				</TR>
			</TABLE>
		</div>

	</xsl:template>

</xsl:stylesheet>
