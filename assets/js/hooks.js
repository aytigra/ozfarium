import topbar from "topbar"

const Hooks = {}

const scrollTop = () => {
  return document.documentElement.scrollTop || document.body.scrollTop
}

const getCurrentScroll = () => {
  const scrollHeight = document.documentElement.scrollHeight || document.body.scrollHeight
  const clientHeight = document.documentElement.clientHeight

  return scrollTop() / (scrollHeight - clientHeight) * 100
}

const scrollCurrentIntoView = () => {
  if (document.querySelector(".current-ozfa")) {
    document.querySelector(".current-ozfa").scrollIntoView(false)
  }
}

Hooks.InfiniteScroll = {
  page() { return parseInt(this.el.dataset.page) },
  last_page() { return parseInt(this.el.dataset.last) },
  mounted() {
    window.stickyOffset = document.getElementById('sticky-nav').offsetTop;

    document.querySelectorAll('#pagination, #filter').forEach(el => {
      el.onclick = function() {
        if (scrollTop() > window.stickyOffset) {
          window.scrollTo({ top: window.stickyOffset })
        }
      }
    })

    /* infinite scroll */
    this.pending = this.page()
    window.addEventListener("scroll", _e => {
      if (this.pending == this.page() &&
          getCurrentScroll() > 90 &&
          this.page() < this.last_page() &&
          !document.querySelector('body').classList.contains('overflow-y-hidden')) {
        this.pending = this.page() + 1
        topbar.show()
        this.pushEvent("load-more", {})
      }
    })
  },
  updated(){
    this.pending = this.page()
    topbar.hide()
  },
  reconnected(){ this.pending = this.page() }
}

Hooks.OpenModal = {
  mounted() {
    document.querySelector('body').classList.add('overflow-y-hidden')
  },
  destroyed() {
    document.querySelector('body').classList.remove('overflow-y-hidden')
    scrollCurrentIntoView()
  },
  updated() {
    scrollCurrentIntoView()
  }
}

export default Hooks
