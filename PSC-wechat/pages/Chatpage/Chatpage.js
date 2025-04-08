Page({
    data: {
      messages: [], // 消息列表
      inputValue: '', // 输入框内容
      scrollToMessage: '', // 滚动到指定消息
      isLoading: false, // 是否正在加载更多消息
      pageSize: 20, // 每页加载消息数量
      currentPage: 1, // 当前页码
      hasMore: true, // 是否还有更多消息
      userInfo: null, // 当前用户信息
      partnerInfo: {
        name: '',
        avatarUrl: '',
        title: '',
        online: false
      },
      ws: null, // WebSocket 连接
      isConnected: false, // WebSocket 连接状态
      reconnectCount: 0, // 重连次数
      maxReconnectCount: 5, // 最大重连次数
      reconnectInterval: 3000, // 重连间隔（毫秒）
      heartbeatInterval: 30000, // 心跳间隔（毫秒）
      heartbeatTimer: null, // 心跳定时器
    },
  
    onLoad(options) {
      // 获取本地存储的用户信息
      this.getUserInfo();
      // 获取对方信息
      this.getPartnerInfo(options.partnerId);
      // 加载消息历史
      this.loadMessages();
      // 初始化 WebSocket 连接
      this.initWebSocket();
    },
  
    onUnload() {
      // 页面卸载时关闭 WebSocket 连接
      this.closeWebSocket();
    },
  
    // 初始化 WebSocket 连接
    initWebSocket() {
      const token = wx.getStorageSync('token');
      const wsUrl = 'YOUR_WEBSOCKET_URL'; // 替换为实际的 WebSocket URL
  
      this.data.ws = wx.connectSocket({
        url: wsUrl,
        data: {
          token: token
        },
        protocols: ['protocol1'],
        success: () => {
          console.log('WebSocket 连接创建成功');
          this.setData({ isConnected: true });
          this.startHeartbeat();
          this.initWebSocketEvents();
        },
        fail: (error) => {
          console.error('WebSocket 连接创建失败:', error);
          this.handleReconnect();
        }
      });
    },
  
    // 初始化 WebSocket 事件监听
    initWebSocketEvents() {
      const ws = this.data.ws;
  
      // 监听连接打开
      ws.onOpen(() => {
        console.log('WebSocket 连接已打开');
        this.setData({ 
          isConnected: true,
          reconnectCount: 0
        });
        // 发送身份认证消息
        this.sendAuthMessage();
      });
  
      // 监听连接关闭
      ws.onClose(() => {
        console.log('WebSocket 连接已关闭');
        this.setData({ isConnected: false });
        this.stopHeartbeat();
        this.handleReconnect();
      });
  
      // 监听连接错误
      ws.onError((error) => {
        console.error('WebSocket 连接错误:', error);
        this.setData({ isConnected: false });
        this.stopHeartbeat();
        this.handleReconnect();
      });
  
      // 监听消息
      ws.onMessage((res) => {
        try {
          const message = JSON.parse(res.data);
          this.handleWebSocketMessage(message);
        } catch (error) {
          console.error('消息解析错误:', error);
        }
      });
    },
  
    // 处理 WebSocket 消息
    handleWebSocketMessage(message) {
      switch (message.type) {
        case 'chat':
          this.handleChatMessage(message);
          break;
        case 'status':
          this.handleStatusMessage(message);
          break;
        case 'heartbeat':
          this.handleHeartbeatMessage(message);
          break;
        default:
          console.warn('未知消息类型:', message.type);
      }
    },
  
    // 处理聊天消息
    handleChatMessage(message) {
      const newMessage = {
        id: message.id,
        content: message.content,
        sender: message.sender,
        time: new Date(message.time),
        timeStr: this.formatTime(new Date(message.time)),
        showTime: this.shouldShowTime(new Date(message.time))
      };
  
      this.setData({
        messages: [...this.data.messages, newMessage]
      }, () => {
        this.scrollToBottom();
      });
    },
  
    // 处理状态消息
    handleStatusMessage(message) {
      this.setData({
        'partnerInfo.online': message.online
      });
    },
  
    // 处理心跳消息
    handleHeartbeatMessage(message) {
      // 可以在这里处理心跳响应
    },
  
    // 发送身份认证消息
    sendAuthMessage() {
      const message = {
        type: 'auth',
        userId: this.data.userInfo.id,
        partnerId: this.data.partnerInfo.id
      };
      this.sendWebSocketMessage(message);
    },
  
    // 发送 WebSocket 消息
    sendWebSocketMessage(message) {
      if (this.data.isConnected && this.data.ws) {
        this.data.ws.send({
          data: JSON.stringify(message),
          success: () => {
            console.log('消息发送成功:', message);
          },
          fail: (error) => {
            console.error('消息发送失败:', error);
            this.handleReconnect();
          }
        });
      } else {
        console.warn('WebSocket 未连接，无法发送消息');
      }
    },
  
    // 开始心跳
    startHeartbeat() {
      this.data.heartbeatTimer = setInterval(() => {
        this.sendWebSocketMessage({
          type: 'heartbeat',
          time: new Date().getTime()
        });
      }, this.data.heartbeatInterval);
    },
  
    // 停止心跳
    stopHeartbeat() {
      if (this.data.heartbeatTimer) {
        clearInterval(this.data.heartbeatTimer);
        this.data.heartbeatTimer = null;
      }
    },
  
    // 处理重连
    handleReconnect() {
      if (this.data.reconnectCount < this.data.maxReconnectCount) {
        this.setData({
          reconnectCount: this.data.reconnectCount + 1
        });
        setTimeout(() => {
          this.initWebSocket();
        }, this.data.reconnectInterval);
      } else {
        wx.showToast({
          title: '连接失败，请重试',
          icon: 'none'
        });
      }
    },
  
    // 关闭 WebSocket 连接
    closeWebSocket() {
      this.stopHeartbeat();
      if (this.data.ws) {
        this.data.ws.close({
          success: () => {
            console.log('WebSocket 连接已关闭');
          }
        });
      }
    },
  
    // 发送消息
    async sendMessage() {
      if (!this.data.inputValue.trim()) return;
  
      const message = {
        type: 'chat',
        content: this.data.inputValue,
        sender: 'user',
        time: new Date().getTime()
      };
  
      // 发送消息到服务器
      this.sendWebSocketMessage(message);
  
      // 清空输入框
      this.setData({
        inputValue: ''
      });
    },
  
    // 滚动到底部
    scrollToBottom() {
      const messages = this.data.messages;
      if (messages.length > 0) {
        const lastMessage = messages[messages.length - 1];
        this.setData({
          scrollToMessage: `msg-${lastMessage.id}`
        });
      }
    },
  
    // 输入框内容变化
    onInput(e) {
      this.setData({
        inputValue: e.detail.value
      });
    },
  
    // 获取当前用户信息
    getUserInfo() {
      const userInfo = wx.getStorageSync('userInfo');
      if (userInfo) {
        this.setData({ userInfo });
      } else {
        wx.redirectTo({
          url: '/pages/FirstPage/FirstPage'
        });
      }
    },
  
    // 获取对方信息
    async getPartnerInfo(partnerId) {
      try {
        const res = await wx.request({
          url: 'http://127.0.0.1:4523/m1/6011225-5700055-default/consultant/info',
          method: 'GET',
          data: {
            consultantId: partnerId
          }
        });
  
        if (res.statusCode === 200 && res.data) {
          this.setData({
            partnerInfo: {
              id: partnerId,
              name: res.data.name,
              avatarUrl: res.data.avatarUrl,
              title: res.data.title,
              online: res.data.online
            }
          });
        } else {
          wx.showToast({
            title: '获取咨询师信息失败',
            icon: 'none'
          });
        }
      } catch (error) {
        console.error('获取咨询师信息失败:', error);
        wx.showToast({
          title: '获取咨询师信息失败',
          icon: 'none'
        });
      }
    },
  
    // 加载消息历史
    async loadMessages(isLoadMore = false) {
      if (this.data.isLoading || (!isLoadMore && !this.data.hasMore)) return;
  
      this.setData({ isLoading: true });
  
      try {
        const res = await wx.request({
          url: 'http://127.0.0.1:4523/m1/6011225-5700055-default/chat/history',
          method: 'GET',
          data: {
            page: this.data.currentPage,
            pageSize: this.data.pageSize,
            partnerId: this.data.partnerInfo.id
          }
        });
  
        if (res.statusCode === 200 && res.data) {
          const newMessages = res.data.messages.map(msg => ({
            id: msg.id,
            content: msg.content,
            sender: msg.sender,
            time: new Date(msg.time),
            timeStr: this.formatTime(new Date(msg.time)),
            showTime: this.shouldShowTime(new Date(msg.time))
          }));
  
          this.setData({
            messages: isLoadMore ? [...newMessages, ...this.data.messages] : newMessages,
            currentPage: this.data.currentPage + 1,
            hasMore: res.data.hasMore,
            isLoading: false
          }, () => {
            if (!isLoadMore) {
              this.scrollToBottom();
            }
          });
        }
      } catch (error) {
        console.error('加载消息历史失败:', error);
        wx.showToast({
          title: '加载消息失败',
          icon: 'none'
        });
        this.setData({ isLoading: false });
      }
    },
  
    // 格式化时间
    formatTime(date) {
      const hours = date.getHours().toString().padStart(2, '0');
      const minutes = date.getMinutes().toString().padStart(2, '0');
      return `${hours}:${minutes}`;
    },
  
    // 是否显示时间分割线
    shouldShowTime(date) {
      const messages = this.data.messages;
      if (messages.length === 0) return true;
  
      const lastMessage = messages[messages.length - 1];
      const lastMessageTime = new Date(lastMessage.time);
      const timeDiff = date - lastMessageTime;
  
      return timeDiff > 5 * 60 * 1000; // 5分钟显示一次时间
    },
  
    // 滚动到顶部加载更多
    onScrollToUpper() {
      if (this.data.hasMore) {
        this.loadMessages(true);
      }
    },
  
    // 返回上一页
    navigateBack() {
      wx.navigateBack();
    }
  });