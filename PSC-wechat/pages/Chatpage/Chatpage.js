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
      }
    },
  
    onLoad(options) {
      // 获取本地存储的用户信息
      this.getUserInfo();
      // 获取对方信息
      this.getPartnerInfo(options.partnerId);
      // 加载消息历史
      this.loadMessages();
    },
  
    // 获取当前用户信息
    getUserInfo() {
      const userInfo = wx.getStorageSync('userInfo');
      if (userInfo) {
        this.setData({ userInfo });
      } else {
        // 如果没有用户信息，跳转到登录页
        wx.redirectTo({
          url: '/pages/FirstPage/FirstPage'
        });
      }
    },
  
    // 获取对方信息
    getPartnerInfo(partnerId) {
      // TODO: 从后端获取对方信息
      // 这里先使用模拟数据
      this.setData({
        partnerInfo: {
          name: '张医生',
          avatarUrl: '/images/default-avatar.png',
          title: '心理咨询师',
          online: true
        }
      });
    },
  
    // 加载消息历史
    async loadMessages(isLoadMore = false) {
      if (this.data.isLoading || (!isLoadMore && !this.data.hasMore)) return;
  
      this.setData({ isLoading: true });
  
      try {
        // TODO: 从后端获取消息历史
        // 这里先使用模拟数据
        setTimeout(() => {
          const newMessages = this.getMockMessages();
          
          this.setData({
            messages: isLoadMore ? [...newMessages, ...this.data.messages] : newMessages,
            isLoading: false,
            currentPage: this.data.currentPage + 1,
            hasMore: newMessages.length === this.data.pageSize
          });
        }, 1000);
      } catch (error) {
        console.error('加载消息失败:', error);
        this.setData({ isLoading: false });
        wx.showToast({
          title: '加载消息失败',
          icon: 'none'
        });
      }
    },
  
    // 生成模拟消息数据
    getMockMessages() {
      const messages = [];
      const now = new Date();
      
      for (let i = 0; i < this.data.pageSize; i++) {
        const messageTime = new Date(now - i * 60000);
        messages.push({
          id: Date.now() - i,
          content: `这是第 ${i + 1} 条测试消息`,
          sender: i % 2 === 0 ? 'partner' : 'user',
          time: messageTime,
          timeStr: this.formatTime(messageTime),
          showTime: i === 0 || i % 5 === 0
        });
      }
      
      return messages;
    },
  
    // 格式化时间
    formatTime(date) {
      const now = new Date();
      const diff = now - date;
      const minutes = Math.floor(diff / 60000);
      
      if (minutes < 1) return '刚刚';
      if (minutes < 60) return `${minutes}分钟前`;
      
      const hours = date.getHours();
      const mins = date.getMinutes();
      return `${hours.toString().padStart(2, '0')}:${mins.toString().padStart(2, '0')}`;
    },
  
    // 输入框内容变化
    onInput(e) {
      this.setData({
        inputValue: e.detail.value
      });
    },
  
    // 发送消息
    async sendMessage() {
      const content = this.data.inputValue.trim();
      if (!content) return;
  
      const message = {
        id: Date.now(),
        content,
        sender: 'user',
        time: new Date(),
        timeStr: '刚刚',
        showTime: this.shouldShowTime()
      };
  
      // 更新UI
      this.setData({
        messages: [...this.data.messages, message],
        inputValue: '',
        scrollToMessage: `msg-${message.id}`
      });
  
      try {
        // TODO: 发送消息到后端
        // 这里先使用模拟回复
        setTimeout(() => {
          const replyMessage = {
            id: Date.now(),
            content: '收到您的消息，我们会尽快回复。',
            sender: 'partner',
            time: new Date(),
            timeStr: '刚刚',
            showTime: this.shouldShowTime()
          };
  
          this.setData({
            messages: [...this.data.messages, replyMessage],
            scrollToMessage: `msg-${replyMessage.id}`
          });
        }, 1000);
      } catch (error) {
        console.error('发送消息失败:', error);
        wx.showToast({
          title: '发送失败',
          icon: 'none'
        });
      }
    },
  
    // 判断是否显示时间
    shouldShowTime() {
      const messages = this.data.messages;
      if (messages.length === 0) return true;
  
      const lastMessage = messages[messages.length - 1];
      const lastTime = new Date(lastMessage.time);
      const now = new Date();
      const diff = now - lastTime;
  
      return diff > 5 * 60 * 1000; // 超过5分钟显示时间
    },
  
    // 上拉加载更多
    onScrollToUpper() {
      if (this.data.hasMore) {
        this.loadMessages(true);
      }
    },
  
    // 返回到MainPage
    navigateBack() {
      wx.navigateBack({
        delta: 1,
        fail: () => {
          wx.redirectTo({
            url: '/pages/MainPage/MainPage'
          });
        }
      });
    }
  });