;; CryptoScope Contract

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-unauthorized (err u100))
(define-constant err-invalid-params (err u101)) 
(define-constant err-not-found (err u102))

;; Data structures
(define-map monitored-addresses
  principal
  {
    active: bool,
    alert-threshold: uint,
    last-checked: uint
  }
)

(define-map activity-logs
  { address: principal, timestamp: uint }
  {
    tx-type: (string-ascii 20),
    amount: uint,
    counter-party: (optional principal),
    description: (optional (string-ascii 100))  ;; Added optional description field
  }
)

(define-map alerts
  uint
  {
    address: principal,
    alert-type: (string-ascii 20),
    timestamp: uint,
    triggered: bool
  }
)

;; State variables 
(define-data-var alert-counter uint u0)

;; Public functions
(define-public (register-monitor (address principal) (alert-threshold uint))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (map-set monitored-addresses
      address
      {
        active: true,
        alert-threshold: alert-threshold,
        last-checked: block-height
      }
    ))
  )
)

(define-public (add-alert (address principal) (alert-type (string-ascii 20)))
  (let ((counter (var-get alert-counter)))
    (begin
      (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
      (var-set alert-counter (+ counter u1))
      (ok (map-set alerts
        counter
        {
          address: address,
          alert-type: alert-type,
          timestamp: block-height,
          triggered: false
        }
      ))
    )
  )
)

(define-public (log-activity (address principal) (tx-type (string-ascii 20)) (amount uint) (counter-party (optional principal)) (description (optional (string-ascii 100))))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-unauthorized)
    (ok (map-set activity-logs
      { address: address, timestamp: block-height }
      {
        tx-type: tx-type,
        amount: amount,
        counter-party: counter-party,
        description: description
      }
    ))
  )
)

;; Read only functions
(define-read-only (get-monitored-status (address principal))
  (match (map-get? monitored-addresses address)
    status (ok status)
    (err err-not-found)
  )
)

(define-read-only (get-activity (address principal))
  (ok (map-get? activity-logs { address: address, timestamp: block-height }))
)

(define-read-only (get-alerts (address principal))
  (ok (filter alerts address))
)
