import 'package:flutter/material.dart';
import 'package:project_topics_movil/src/pages/history/widgets/complaint_item.dart';
import 'package:project_topics_movil/src/utils/index.dart';

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

  String filter = '';
  String _optionSelectType = '';
  String _optionSelectState = 'pendiente';

  void filterList(List<Complaint> complaintList) {
    complaintsListFilter = [];

    if (filter == 'tipo') {
      for (var i = 0; i < complaintList.length; i++) {
        if (complaintList[i].categoryId == _optionSelectType) {
          complaintsListFilter.add(complaintList[i]);
        }
      }
    }
    if (filter == 'state') {
      for (var i = 0; i < complaintList.length; i++) {
        if (complaintList[i].state == _optionSelectState) {
          complaintsListFilter.add(complaintList[i]);
        }
      }
    }
    //filtrar por fecha
  }

  @override
  Widget build(BuildContext context) {
    final complaintService = Provider.of<ComplaintService>(context);
    final categoryService = Provider.of<CategoryService>(context);

    if (complaintService.isLoading || categoryService.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (filter == '') {
      complaintsListFilter = complaintService.complaitsList;
    }
    if (_optionSelectType == '') {
      _optionSelectType = categoryService.categoryList[0].id;
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
                            categoryId: ""),
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
                      filter = '';
                      complaintsListFilter = complaintService.complaitsList;
                    });
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(left: 5, top: 12),
                    child: Text(
                      'Todos',
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
                      // complaintForm.isLoading = false;
                      setState(() {
                        _optionSelectState = value!;
                        filter = 'state';
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
                    items: categoryService.dropdownList,
                    onChanged: (value) {
                      // complaintForm.isLoading = false;
                      setState(() {
                        _optionSelectType = value!;
                        filter = 'tipo';
                        filterList(complaintService.complaitsList);
                      });
                    },
                  ),
                ),
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
                return ComplaintItem(
                  complaint: complaintsListFilter[index],
                  delay: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
