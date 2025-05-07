const app = getApp();
Page({
  data: {
    messages: [],
    inputMessage: '',
    socketTask: null,
    counselor: null,
    isConnected: false,
    showEmojiPicker: false,
    emojiList: ['😊', '😃', '😉', '😍', '😘', '😎', '😁', '😆', '😋', '😜', '😢', '😡', '👍', '🙏', '🎉', '❤️', '🔥', '🤔', '👏', '💬'],
    showRatingDialog: false,
    selectedRating: 0
  },

  onLoad() {
    const counselor = wx.getStorageSync('selectedCounselor');
    if (!counselor) {
      wx.showToast({ title: '未选择咨询师', icon: 'none' });
      wx.navigateBack();
      return;
    }
    this.setData({ counselor });
    wx.setNavigationBarTitle({ title: counselor.name }); // 设置导航栏姓名
    this.connectWebSocket();
  },

  onUnload() {
    if (this.data.socketTask) {
      this.data.socketTask.close({
        success: () => console.log('WebSocket 已关闭'),
        fail: (err) => console.error('关闭 WebSocket 失败:', err)
      });
    }
  },

  connectWebSocket() {
    const token = wx.getStorageSync('token');
    if (!token) {
      wx.showToast({ title: '未登录', icon: 'none' });
      return;
    }

    const socketTask = wx.connectSocket({
      url: `wss://soyorinlove.me/api/ws/user/${token}`,
    });

    socketTask.onOpen(() => {
      console.log('WebSocket连接已打开');
      this.setData({ isConnected: true });
      this.setupSession();
      
      // 更新tabBar状态
      wx.setTabBarItem({
        index: 1,
        text: '咨询会话',
        pagePath: 'pages/Chatpage/Chatpage'
      });
    });

    socketTask.onMessage((res) => {
        const counselor = wx.getStorageSync('selectedCounselor');
      try {
        const message = JSON.parse(res.data);
        if(message.fromId==counselor.id){
            this.handleMessage(message);
        }
      } catch (e) {
        console.error('消息解析错误:', e);
      }

    });

    socketTask.onClose(() => {
      this.setData({ isConnected: false });
      // 更新tabBar状态
      wx.setTabBarItem({
        index: 1,
        text: '暂无咨询',
        pagePath: 'pages/Chat/Chat1'
      });
    });

    socketTask.onError(() => {
      wx.showToast({ title: '连接错误', icon: 'none' });
      this.setData({ isConnected: false });
      // 更新tabBar状态
      wx.setTabBarItem({
        index: 1,
        text: '暂无咨询',
        pagePath: 'pages/Chat/Chat1'
      });
    });

    this.setData({ socketTask });
  },

  setupSession() {
    const { counselor } = this.data;
    const token = wx.getStorageSync('token');
    wx.request({
      url: `${app.globalData.BaseUrl}/setSession/${counselor.id}`,
      method: 'POST',
      header: { token },
    });
  },

  handleMessage(message) {
    this.setData({
      messages: [...this.data.messages, message]
    });

    wx.nextTick(() => {
      this.scrollToBottom();
    });
  },

  scrollToBottom() {
    this.setData({
      toView: 'bottom'
    });
  },

  onInputChange(e) {
    this.setData({ inputMessage: e.detail.value });
  },

  toggleEmojiPicker() {
    this.setData({ showEmojiPicker: !this.data.showEmojiPicker });
  },

  selectEmoji(e) {
    const emoji = e.currentTarget.dataset.emoji;
    this.setData({ inputMessage: this.data.inputMessage + emoji });
  },

  sendMessage() {
    const { inputMessage, counselor, socketTask, isConnected } = this.data;
    if (!inputMessage.trim()) {
      wx.showToast({ title: '消息不能为空', icon: 'none' });
      return;
    }
    if (!isConnected || !socketTask) {
      wx.showToast({ title: '连接未就绪', icon: 'none' });
      this.connectWebSocket();
      return;
    }

    const message = {
      toId: counselor.id,
      messageType: 'text',
      message: inputMessage,
      meta: null
    };

    socketTask.send({
      data: JSON.stringify(message),
      success: () => {
        this.handleMessage({
          ...message,
          isSelf: true,
          status: 'sent'
        });
        this.setData({ inputMessage: '', showEmojiPicker: false });
      },
      fail: () => {
        wx.showToast({ title: '发送失败', icon: 'none' });
        this.handleMessage({
          ...message,
          isSelf: true,
          status: 'failed'
        });
      }
    });
  },

  showRatingDialog() {
    this.setData({
      showRatingDialog: true,
      selectedRating: 0
    });
  },

  hideRatingDialog() {
    this.setData({
      showRatingDialog: false,
      selectedRating: 0
    });
  },

  selectRating(e) {
    const rating = e.currentTarget.dataset.rating;
    this.setData({
      selectedRating: rating
    });
  },

  submitRating() {
    if (!this.data.selectedRating) {
      return;
    }

    const token = wx.getStorageSync('token');
    const { counselor } = this.data;

    wx.request({
      url: `${app.globalData.BaseUrl}`+'/endSession', // 请替换为实际的评分API地址
      method: 'POST',
      header: {
        'token': token,
        'Content-Type': 'application/json'
      },
      data: {
        counselorId: counselor.id,
        score: this.data.selectedRating
      },
      success: (res) => {
        if (res.statusCode === 200) {
          wx.showToast({
            title: '评分成功',
            icon: 'success',
            duration: 2000
          });
          // 返回主页面
          wx.reLaunch({
            url: '/pages/MainPage/MainPage'
          });
        } else {
          wx.showToast({
            title: '评分失败',
            icon: 'none',
            duration: 2000
          });
        }
      },
      fail: () => {
        wx.showToast({
          title: '网络错误',
          icon: 'none',
          duration: 2000
        });
      }
    });
  },

  goBackMainPage() {
    wx.reLaunch({
      url: '/pages/MainPage/MainPage'
    });
  }
});
