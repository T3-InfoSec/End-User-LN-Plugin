// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tlp_connection_plugin/tlp/tlp.dart';
import 'package:tlp_connection_plugin/tlp_connection_plugin.dart';

class TlpBottomSheet extends StatefulWidget {
  const TlpBottomSheet({required this.tlpConnectionPlugin, super.key});
  final TlpConnectionPlugin tlpConnectionPlugin;

  @override
  State<TlpBottomSheet> createState() => _TlpBottomSheetState();
}

class _TlpBottomSheetState extends State<TlpBottomSheet> {
  late TLP tlpInstance;

  // Computation variables
  final int bitsPrimes = 256;
  late BigInt prime1, prime2, product, baseG, base2, t, fastPower;

  @override
  void initState() {
    super.initState();
    _initializeTlpValues();
  }

  /// Initializes TLP computation values.
  void _initializeTlpValues() {
    tlpInstance = TLP(bits: bitsPrimes);

    prime1 = tlpInstance.generatedPrime;
    prime2 = tlpInstance.generatedPrime;
    baseG = tlpInstance.generatedBase;
    base2 = tlpInstance.generatedBase;
    product = tlpInstance.comupteProductOfPrime(prime1, prime2);
    t = BigInt.from(3000);

    final carmichael = tlpInstance.calculateCarmichael(prime1, prime2);
    final fastExponent = tlpInstance.modExp(base2, t, carmichael);
    fastPower = tlpInstance.modExp(baseG, fastExponent, product);
  }

  /// Updates the state for recalculating fast power.
  void _recalculateFastPower() {
    setState(() {
      _initializeTlpValues();
    });
  }

  /// Sends a message to retrieve slow power (to be implemented).
  void _sendMessageToGetSlowPower() {
    // Placeholder for future implementation
    debugPrint("Send message to get slow power (not implemented).");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.symmetric(horizontal: 16).copyWith(top: 32),
      child: StreamBuilder<ConnectionStatus>(
        stream: widget.tlpConnectionPlugin.connectionStatusStream,
        builder: (context, connectionSnapshot) {
          final connectionStatus = connectionSnapshot.data?.name ?? 'Unknown';

          return StreamBuilder<dynamic>(
            stream: widget.tlpConnectionPlugin.receivedMessageStream,
            builder: (context, messageSnapshot) {
              final receivedMessage = messageSnapshot.data ?? 'No message received';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Connection Status Display
                  _buildStatusText("Status: $connectionStatus"),

                  const SizedBox(height: 16),
                  const Text("Fast Power Answer:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDisplayBox(fastPower.toString()),

                  const SizedBox(height: 16),
                  const Text("TLP Answer:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  _buildDisplayBox(receivedMessage),

                  const SizedBox(height: 32),

                  const SizedBox(height: 32),

                  // Send Message Button
                  if (fastPower != BigInt.tryParse(receivedMessage))
                    _buildSendMessageButton()
                  else
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 48)),
                        backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                      label: const Text("DONE"),
                      icon: const Icon(Icons.close),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDisplayBox(String content) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Center(
        child: Text(
          content,
          style: TextStyle(color: Colors.grey[600]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildStatusText(String status) {
    return Text(
      status,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
  }

  /// Builds the button to send a TLP message.
  Widget _buildSendMessageButton() {
    return ElevatedButton(
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(const Size(double.infinity, 48)),
        backgroundColor: MaterialStateProperty.all(Colors.blue),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      onPressed: () {
        widget.tlpConnectionPlugin.sendMessage(
          '{"baseg":$baseG,"t":$t,"product":$product}',
          MessageType.tlp,
        );
      },
      child: const Text("Send Message"),
    );
  }
}
