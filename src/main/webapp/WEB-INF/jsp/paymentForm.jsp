<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <title>Payment — SmartEvent</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.0/font/bootstrap-icons.css"/>
    <style>
        * { font-family: "Segoe UI", sans-serif; }
        .navbar { background:#fff; border-bottom:1px solid #eee; padding:16px 0; }
        .navbar-brand { font-weight:700; font-size:1.3rem; color:#1a1a2e !important; }
        .navbar-brand i { color:#4f46e5; }
        .nav-link { color:#555 !important; font-weight:500; }
        .card-preview {
            background: linear-gradient(135deg, #1a1a2e 0%, #4f46e5 100%);
            border-radius: 16px;
            color: #fff;
            padding: 28px;
            min-height: 160px;
            position: relative;
        }
        .card-preview .chip {
            width: 36px; height: 28px;
            background: linear-gradient(135deg, #f6d365, #fda085);
            border-radius: 6px;
            margin-bottom: 20px;
        }
        .pay-btn {
            background: #4f46e5;
            color: #fff;
            border: none;
            border-radius: 10px;
            padding: 14px;
            font-size: 1.05rem;
            font-weight: 600;
            width: 100%;
            transition: background 0.2s;
        }
        .pay-btn:hover { background: #4338ca; color: #fff; }
        .security-badge { font-size: 0.8rem; color: #6b7280; }
    </style>
</head>
<body style="background:#f8f9ff">

<nav class="navbar navbar-expand-lg sticky-top">
    <div class="container">
        <a class="navbar-brand" href="/WebTechProject/events">
            <i class="bi bi-calendar-event-fill me-2"></i>SmartEvent
        </a>
        <div class="collapse navbar-collapse">
            <ul class="navbar-nav ms-auto align-items-center gap-3">
                <li class="nav-item"><a class="nav-link" href="/WebTechProject/events">Discover</a></li>
                <li class="nav-item"><a class="nav-link" href="/WebTechProject/my-tickets">My Tickets</a></li>
                <li class="nav-item"><span class="nav-link text-muted">${sessionScope.user.fullName}</span></li>
                <li class="nav-item"><a class="nav-link" href="/WebTechProject/logout">Logout</a></li>
            </ul>
        </div>
    </div>
</nav>

<div class="container mt-5" style="max-width:500px">
    <a href="/WebTechProject/events/${event.id}" class="btn btn-outline-secondary mb-4">
        <i class="bi bi-arrow-left me-1"></i>Back to event
    </a>

    <%-- Order summary --%>
    <div class="card shadow-sm p-4 mb-4">
        <h6 class="text-muted text-uppercase fw-semibold mb-3" style="font-size:0.75rem; letter-spacing:.05em">Order summary</h6>
        <div class="d-flex justify-content-between align-items-center">
            <div>
                <div class="fw-semibold">${event.title}</div>
                <div class="text-muted small"><i class="bi bi-calendar3 me-1"></i>${event.formattedDateTime}</div>
                <div class="text-muted small"><i class="bi bi-geo-alt me-1"></i>${event.location}</div>
            </div>
            <div class="fs-4 fw-bold" style="color:#4f46e5">${event.price} €</div>
        </div>
    </div>

    <%-- Card preview --%>
    <div class="card-preview mb-4">
        <div class="chip"></div>
        <div id="previewNumber" class="mb-3" style="font-size:1.1rem; letter-spacing:0.15em; font-family:monospace">
            •••• •••• •••• ••••
        </div>
        <div class="d-flex justify-content-between align-items-end">
            <div>
                <div style="font-size:0.7rem; opacity:0.7">CARD HOLDER</div>
                <div id="previewName" style="font-size:0.9rem">YOUR NAME</div>
            </div>
            <div>
                <div style="font-size:0.7rem; opacity:0.7">EXPIRES</div>
                <div id="previewExpiry" style="font-size:0.9rem">MM/YY</div>
            </div>
        </div>
    </div>

    <%-- Payment form --%>
    <div class="card shadow-sm p-4">
        <h5 class="fw-bold mb-4"><i class="bi bi-credit-card me-2"></i>Card details</h5>
        <form method="post" action="/WebTechProject/events/${event.id}/pay">
            <div class="mb-3">
                <label class="form-label fw-semibold">Cardholder name</label>
                <input type="text" class="form-control" id="cardName" placeholder="John Doe" required/>
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Card number</label>
                <input type="text" class="form-control" id="cardNumber"
                       placeholder="1234 5678 9012 3456" maxlength="19" required/>
            </div>
            <div class="row g-3 mb-4">
                <div class="col-7">
                    <label class="form-label fw-semibold">Expiry date</label>
                    <input type="text" class="form-control" id="cardExpiry"
                           placeholder="MM/YY" maxlength="5" required/>
                </div>
                <div class="col-5">
                    <label class="form-label fw-semibold">CVV</label>
                    <input type="text" class="form-control" placeholder="•••" maxlength="3" required/>
                </div>
            </div>
            <button type="submit" class="pay-btn">
                <i class="bi bi-lock-fill me-2"></i>Pay ${event.price} €
            </button>
        </form>
        <div class="text-center security-badge mt-3">
            <i class="bi bi-shield-check me-1"></i>Simulated secure payment — no real charge
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const cardNumber = document.getElementById('cardNumber');
    const cardName = document.getElementById('cardName');
    const cardExpiry = document.getElementById('cardExpiry');
    const previewNumber = document.getElementById('previewNumber');
    const previewName = document.getElementById('previewName');
    const previewExpiry = document.getElementById('previewExpiry');

    cardNumber.addEventListener('input', function () {
        let val = this.value.replace(/\D/g, '').substring(0, 16);
        this.value = val.replace(/(.{4})/g, '$1 ').trim();
        previewNumber.textContent = this.value || '•••• •••• •••• ••••';
    });
    cardName.addEventListener('input', function () {
        previewName.textContent = this.value.toUpperCase() || 'YOUR NAME';
    });
    cardExpiry.addEventListener('input', function () {
        let val = this.value.replace(/\D/g, '').substring(0, 4);
        if (val.length >= 2) val = val.substring(0, 2) + '/' + val.substring(2);
        this.value = val;
        previewExpiry.textContent = this.value || 'MM/YY';
    });
</script>
</body>
</html>
