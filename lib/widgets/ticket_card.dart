import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketCard extends StatelessWidget {
  final Ticket ticket;
  final Function()? onTap;
  final bool isExpanded;

  const TicketCard({
    super.key,
    required this.ticket,
    this.onTap,
    this.isExpanded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTicketHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildRouteInfo(),
                  const SizedBox(height: 12),
                  _buildDateInfo(),
                  if (isExpanded) ...[
                    const Divider(height: 24),
                    _buildExpandedDetails(context),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            ticket.type.toUpperCase(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getStatusColor(),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              ticket.isActive ? "ACTIVE" : "EXPIRED",
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfo() {
    return Row(
      children: [
        const Icon(Icons.directions_bus, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                ticket.routeName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "${ticket.startPoint} → ${ticket.endPoint}",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Text(
          "₦${ticket.price.toStringAsFixed(2)}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildDateInfo() {
    final formatter = DateFormat('MMM dd, yyyy • hh:mm a');
    return Row(
      children: [
        const Icon(Icons.access_time, size: 20, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          formatter.format(ticket.purchaseDate),
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedDetails(BuildContext context) {
    final formatter = DateFormat('MMM dd, yyyy • hh:mm a');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: QrImageView(
            data: ticket.id,
            version: QrVersions.auto,
            size: 160.0,
          ),
        ),
        const SizedBox(height: 16),
        _buildDetailRow("Ticket ID", ticket.id.substring(0, 8)),
        _buildDetailRow("Passenger", ticket.passengerName),
        _buildDetailRow("Valid Until", formatter.format(ticket.expiryDate)),
        if (ticket.isRoundTrip) _buildDetailRow("Type", "Round Trip"),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: () {
            // You can hook this to a download method
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Download initiated...")),
            );
          },
          icon: const Icon(Icons.download),
          label: const Text("Download Ticket"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    if (!ticket.isActive) return Colors.grey;
    if (ticket.expiryDate.difference(DateTime.now()).inHours < 6) return Colors.orange;
    return Colors.green;
  }
}