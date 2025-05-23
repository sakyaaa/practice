import consumer from "./consumer"

document.addEventListener('turbo:load', () => {
  const followRequestsContainer = document.getElementById('follow-requests-container')
  
  if (followRequestsContainer) {
    consumer.subscriptions.create("FollowRequestsChannel", {
      connected() {
        console.log("Connected to FollowRequestsChannel")
      },

      disconnected() {
        console.log("Disconnected from FollowRequestsChannel")
      },

      received(data) {
        const notification = document.createElement('div')
        notification.className = 'notification'
        notification.innerHTML = `
          <p>${data.message}</p>
          ${data.type === 'follow_request' ? `
            <div class="follow-request-actions">
              <button onclick="acceptFollowRequest(${data.follow_request_id})">Accept</button>
              <button onclick="rejectFollowRequest(${data.follow_request_id})">Reject</button>
            </div>
          ` : ''}
        `
        followRequestsContainer.prepend(notification)
      }
    })
  }
})

function acceptFollowRequest(id) {
  fetch(`/follow_requests/${id}/accept`, {
    method: 'POST',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      'Content-Type': 'application/json'
    }
  })
}

function rejectFollowRequest(id) {
  fetch(`/follow_requests/${id}/reject`, {
    method: 'POST',
    headers: {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      'Content-Type': 'application/json'
    }
  })
}
