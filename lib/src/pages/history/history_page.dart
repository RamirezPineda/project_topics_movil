import 'package:flutter/material.dart';
import 'package:project_topics_movil/src/pages/history/widgets/complaint_item.dart';

import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:project_topics_movil/src/services/index.dart';
import 'package:project_topics_movil/src/widgets/index.dart';
import 'package:project_topics_movil/src/models/index.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Complaint> complaintsListFilter = [];
  String _optionSelectType = "";
  String _optionSelectState = "";
  DateTime? _startDate;
  DateTime? _endDate;

  void filterList(List<Complaint> complaintList) {
    complaintsListFilter = [];

    for (var i = 0; i < complaintList.length; i++) {
      final complaint = complaintList[i];

      if (_optionSelectType != "") {
        if (_optionSelectType != complaint.typeComplaintId) continue;
      }

      if (_startDate != null && _endDate != null) {
        final complaintDate = complaintList[i].createdAt;
        if (complaintDate!.isBefore(_startDate!) ||
            complaintDate.isAfter(_endDate!)) {
          continue;
        }
      }

      if (_optionSelectState != "") {
        if (_optionSelectState != complaint.state) continue;
      }

      complaintsListFilter.add(complaint);
    }
  }

  @override
  Widget build(BuildContext context) {
    final complaintService = Provider.of<ComplaintService>(context);
    final typeComplaintService = Provider.of<TypeComplaintService>(context);

    if (complaintService.isLoading || typeComplaintService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_optionSelectType == "" &&
        _optionSelectState == "" &&
        (_startDate == null || _endDate == null)) {
      complaintsListFilter = complaintService.complaitsList;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mi historial',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),

              // Add Complaint Button
              InkWell(
                onTap: () async {
                  // Add complaint
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintCard(
                        complaint: Complaint(
                            title: '',
                            description: '',
                            photos: [],
                            state: "",
                            typeComplaintId: ""),
                      ),
                    ),
                  );
                },
                child: Container(
                  height: 40,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),
          const Divider(color: Colors.grey, thickness: 1),
          const SizedBox(height: 5),

          // Filters
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _optionSelectType = "";
                      _optionSelectState = "";
                      _startDate = null;
                      _endDate = null;
                      complaintsListFilter = complaintService.complaitsList;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 12),
                    child: Text(
                      'Limpiar filtro',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                //Filtrado por estados
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(10),
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    value: _optionSelectState,
                    items: complaintService.dropdownList,
                    onChanged: (value) {
                      setState(() {
                        _optionSelectState = value!;
                        filterList(complaintService.complaitsList);
                      });
                    },
                  ),
                ),

                // Filtrado por tipo de denuncia
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownButton(
                    borderRadius: BorderRadius.circular(10),
                    style: GoogleFonts.montserrat(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    value: _optionSelectType,
                    items: typeComplaintService.dropdownList,
                    onChanged: (value) {
                      setState(() {
                        _optionSelectType = value!;
                        filterList(complaintService.complaitsList);
                      });
                    },
                  ),
                ),

                //Filtrado por rango de fechas
                // Fecha inicio
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton.icon(
                    onPressed: () async {
                      _startDate = await _selectDate(context);
                      setState(() {
                        filterList(complaintService.complaitsList);
                      });
                    },
                    icon: const Icon(Icons.calendar_month, color: Colors.black),
                    label: Text(
                      'Fecha inicio: ${_startDate != null ? _startDate.toString().substring(0, 10) : ''}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: TextButton.icon(
                    onPressed: () async {
                      _endDate = await _selectDate(context);
                      if (_endDate != null) {
                        _endDate = DateTime(_endDate!.year, _endDate!.month,
                            _endDate!.day, 23, 59, 59);
                      }
                      setState(() {
                        filterList(complaintService.complaitsList);
                      });
                    },
                    icon: const Icon(Icons.calendar_month, color: Colors.black),
                    label: Text(
                      'Fecha fin: ${_endDate != null ? _endDate.toString().substring(0, 10) : ''}',
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                // en filter date
              ],
            ),
          ),

          //End filters
          const SizedBox(height: 10),

          // Complaint List
          Expanded(
            child: ListView.builder(
              itemCount: complaintsListFilter.length,
              itemBuilder: (context, index) {
                final complaint = complaintsListFilter[index];
                return ComplaintItem(complaint: complaint, delay: index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2025),
    );

    return picked;
  }
}
