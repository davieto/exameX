import csv
from io import StringIO

def provas_para_csv(provas):
    buffer = StringIO()
    writer = csv.writer(buffer)
    writer.writerow(["ID", "Título", "Descrição"])
    for p in provas:
        writer.writerow([p.idProva, p.titulo, p.descricao])
    return buffer.getvalue()