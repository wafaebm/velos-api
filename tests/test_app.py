from app import app


def test_sante():
    client = app.test_client()
    reponse = client.get("/sante")
    assert reponse.status_code == 200
    assert reponse.get_json()["statut"] == "ok"


def test_alertes():
    client = app.test_client()
    reponse = client.get("/alertes")
    donnees = reponse.get_json()

    assert reponse.status_code == 200
    assert donnees["source"] == "memoire"
    assert len(donnees["stations"]) == 2
    assert all(s["velos_disponibles"] <= 2 for s in donnees["stations"])
