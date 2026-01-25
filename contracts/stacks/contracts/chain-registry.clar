;; FundRaiser - Crowdfunding platform
(define-constant ERR-NOT-FOUND (err u100))
(define-constant ERR-GOAL-NOT-REACHED (err u101))

(define-map campaigns
    { campaign-id: uint }
    { creator: principal, goal: uint, raised: uint, milestones: uint, released: uint, active: bool }
)

(define-map contributions { campaign-id: uint, contributor: principal } { amount: uint })
(define-data-var campaign-counter uint u0)

(define-public (create-campaign (goal uint) (milestones uint))
    (let ((id (var-get campaign-counter)))
        (map-set campaigns { campaign-id: id } {
            creator: tx-sender,
            goal: goal,
            raised: u0,
            milestones: milestones,
            released: u0,
            active: true
        })
        (var-set campaign-counter (+ id u1))
        (ok id)
    )
)

(define-public (contribute (campaign-id uint) (amount uint))
    (let ((campaign (unwrap! (map-get? campaigns { campaign-id: campaign-id }) ERR-NOT-FOUND)))
        (map-set campaigns { campaign-id: campaign-id } (merge campaign { raised: (+ (get raised campaign) amount) }))
        (let ((current-contribution (default-to { amount: u0 } (map-get? contributions { campaign-id: campaign-id, contributor: tx-sender }))))
            (map-set contributions { campaign-id: campaign-id, contributor: tx-sender } { amount: (+ (get amount current-contribution) amount) })
        )
        (ok true)
    )
)

(define-read-only (get-campaign (campaign-id uint))
    (map-get? campaigns { campaign-id: campaign-id })
)
