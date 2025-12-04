from fastapi import APIRouter, HTTPException
from app.services.omr_live_service import processar_video

router = APIRouter(prefix="/correcao", tags=["Correção Ao Vivo"])

@router.post("/ao-vivo")
async def correcao_ao_vivo():
    """
    Ativa a câmera do servidor e executa o modo OMR ao vivo.
    Mostra a imagem processada em tempo real.
    """
    try:
        processar_video()
        return {"status": "ok", "mensagem": "Modo OMR ao vivo executado com sucesso."}
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))