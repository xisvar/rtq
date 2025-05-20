import 'package:flutter/material.dart';
import '../models/bus.dart';

class BusInfoCard extends StatelessWidget {
  final Bus bus;
  final VoidCallback onClose;

  const BusInfoCard({
    super.key,
    required this.bus,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.directions_bus,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                    SizedBox(width: 8),
                    Text(
                      bus.busNumber,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: onClose,
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              bus.routeName,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16),
            _buildInfoRow(
              context,
              'Estimated Arrival',
              bus.estimatedArrival,
              Icons.access_time,
            ),
            _buildInfoRow(
              context,
              'Passenger Load',
              '${bus.loadStatus} (${bus.passengerCount}/${bus.capacity})',
              Icons.people,
              color: _getLoadColor(bus.loadPercentage),
            ),
            _buildInfoRow(
              context,
              'Current Speed',
              '${bus.speed.toStringAsFixed(1)} km/h',
              Icons.speed,
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  // Navigate to detailed route view or buy ticket
                  Navigator.pushNamed(context, '/tickets', arguments: bus.routeId);
                },
                child: Text('Buy Ticket'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: color ?? Theme.of(context).primaryColor,
          ),
          SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLoadColor(double loadPercentage) {
    if (loadPercentage < 50) return Colors.green;
    if (loadPercentage < 80) return Colors.orange;
    return Colors.red;
  }
}
