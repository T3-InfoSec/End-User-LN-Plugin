import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tlp_connection_plugin/data/db/db.dart';
import 'package:tlp_connection_plugin/tlp_connection_plugin.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({required this.plugin, super.key});
  final TlpConnectionPlugin plugin;

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: FutureBuilder<List<TlpData>>(
          future: database.select(database.tlpDatas).get(),
          builder: (context, snapshot) {
            final datas = snapshot.data ?? [];
            return ListView.builder(
              itemCount: datas.length,
              itemBuilder: (context, index) {
                final data = datas[index];
                String formattedDate = DateFormat('yyyy-MM-dd (h:mm)').format(data.createdAt ?? DateTime.now());

                return ListTile(
                  onTap: () {
                    widget.plugin.sendComplain(data.mkey);
                  },
                  leading: CircleAvatar(
                    child: Text('${index + 1}'),
                  ),
                  title: Text(
                    data.mData,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(formattedDate),
                );
              },
            );
          }),
    );
  }
}
