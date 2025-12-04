from fastapi import APIRouter, WebSocket
import base64
import numpy as np
import cv2 as cv
from pyzbar.pyzbar import decode
from app.db import SessionLocal
from app.models.prova_model import Prova
from app.models.questao_objetiva_model import QuestaoObjetiva
from app.services.omr_live_service import (
    corrigePerspectiva, identificar_lacunas,
    identificaMarcacoes
)

router = APIRouter(prefix="/correcao", tags=["Correção - Stream"])

@router.websocket("/stream")
async def correcao_stream(websocket: WebSocket):
    await websocket.accept()
    db = SessionLocal()
    try:
        while True:
            data = await websocket.receive_text()
            # Frame vem em base64
            frame_bytes = base64.b64decode(data)
            npimg = np.frombuffer(frame_bytes, np.uint8)
            frame = cv.imdecode(npimg, cv.IMREAD_COLOR)

            decoded = decode(frame)
            idProva = None
            for d in decoded:
                v = d.data.decode("utf-8")
                if v.startswith("prova:"):
                    idProva = int(v.split(":")[1])
                    break

            if idProva:
                gray = cv.cvtColor(frame, cv.COLOR_BGR2GRAY)
                blur = cv.GaussianBlur(gray, (11, 11), 1)
                _, binaria = cv.threshold(blur, 127, 255, 1)
                conts, _ = cv.findContours(binaria, cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE)
                if not conts:
                    continue
                maior = max(conts, key=cv.contourArea)
                img_persp = corrigePerspectiva(frame, maior)
                img_area = img_persp[340:1300, 40:1040]
                conts_area, bin_area = cv.findContours(
                    cv.cvtColor(img_area, cv.COLOR_BGR2GRAY),
                    cv.RETR_TREE, cv.CHAIN_APPROX_SIMPLE
                )
                lacunas, _ = identificar_lacunas(conts_area, img_area)
                respostas, _ = identificaMarcacoes(lacunas, img_area, bin_area)

                prova = db.query(Prova).filter_by(idProva=idProva).first()
                if not prova:
                    continue

                questoes = [v.idQuestaoObjetiva for v in prova.questoes_objetivas]
                objs = db.query(QuestaoObjetiva).filter(
                    QuestaoObjetiva.idQuestaoObjetiva.in_(questoes)).all()
                gabarito = []
                for q in objs:
                    correta = next((a for a in q.alternativas if a.afirmativa == 1), None)
                    gabarito.append(chr(65 + q.alternativas.index(correta)) if correta else "A")

                acertos = sum(1 for r,g in zip(respostas, gabarito) if r==g)
                nota = round(acertos / len(gabarito) * 10, 2)

                await websocket.send_json({
                    "idProva": idProva,
                    "respostas": respostas,
                    "gabarito": gabarito,
                    "acertos": acertos,
                    "nota": nota
                })
    except Exception as e:
        print("Erro stream:", e)
    finally:
        db.close()
        await websocket.close()