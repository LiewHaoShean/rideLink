import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ride_link_carpooling/flutter_flow/flutter_flow_theme.dart';
import 'package:ride_link_carpooling/flutter_flow/flutter_flow_util.dart';
import 'package:ride_link_carpooling/screens/user/search_ride/search_ride_details/search_ride_details_widget.dart';

class RideCard extends StatelessWidget {
  final String tripId; // Unique identifier for the trip
  final String time;
  final String fromName;
  final String toName;
  final String driverName;
  final String gender; // e.g. 'male' or 'female'
  final double price;
  final String creatorId;
  final int seatNeeded;

  const RideCard({
    Key? key,
    required this.tripId,
    required this.time,
    required this.fromName,
    required this.toName,
    required this.driverName,
    required this.gender,
    required this.price,
    required this.creatorId,
    required this.seatNeeded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () async {
          context.pushNamed(
            SearchRideDetailsWidget.routeName,
            queryParameters: {
              'rideId': tripId, 
              'creatorId': creatorId,
              'seatNeeded': seatNeeded.toString(),
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            boxShadow: [
              BoxShadow(
                blurRadius: 4,
                color: const Color(0x33000000),
                offset: const Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: [
              // Top Row: Time, Route
              Row(
                children: [
                  Container(
                    width: 97.9,
                    height: 108,
                    alignment: Alignment.center,
                    child: Text(
                      time,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: const Color(0xFF00265C),
                            fontSize: 16,
                          ),
                    ),
                  ),
                  Container(
                    width: 23.7,
                    height: 108,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.circle_outlined,
                            color: Color(0xFF00275C), size: 16),
                        SizedBox(height: 5),
                        SizedBox(
                          width: 2,
                          height: 35,
                          child: DecoratedBox(
                            decoration:
                                BoxDecoration(color: Color(0xFF00275C)),
                          ),
                        ),
                        SizedBox(height: 5),
                        Icon(Icons.circle_outlined,
                            color: Color(0xFF00275C), size: 16),
                      ],
                    ),
                  ),
                  Container(
                    width: 249.7,
                    height: 108,
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fromName,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                              color: const Color(0xFF00265C),
                            ),
                          ),
                          Text(
                            toName,
                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                              ),
                              color: const Color(0xFF00265C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Bottom Row: Driver, Gender, Price
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 80,
                    alignment: Alignment.center,
                    child: Container(
                      width: 55,
                      height: 55,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryText,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 80,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          Text(
                            driverName,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                  ),
                                  fontSize: 18,
                                ),
                          ),
                          const SizedBox(width: 5),
                          Icon(
                            gender == 'male'
                                ? Icons.male_rounded
                                : Icons.female_rounded,
                              color: gender == 'male' ? FlutterFlowTheme.of(context).secondary : Colors.pink,
                            size: 30,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: 108,
                    height: 80,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsetsDirectional.only(end: 10),
                    child: Text(
                      'RM ${price.toStringAsFixed(2)}',
                      style: FlutterFlowTheme.of(context).titleLarge.override(
                            font: GoogleFonts.interTight(),
                            color: const Color(0xFF00265C),
                          ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}